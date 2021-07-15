module FacilitiesManagement
  module RM3830
    module Procurements
      class ContractDetailsController < FacilitiesManagement::FrameworkController
        include FacilitiesManagement::PageDetail::RM3830::ContractDetails

        before_action :set_procurement
        before_action :authorize_user
        before_action :redirect_if_not_da_draft
        before_action :redirect_if_not_in_contract_details, only: :edit
        before_action :return_to_results, only: :update, if: -> { params['return_to_results'].present? }
        before_action :set_page_name
        before_action :redirect_if_unrecognised_page_name, only: :edit
        before_action :initialize_page_description_from_view_name, only: %i[show edit]
        before_action :delete_incomplete_contact_details, only: %i[show edit]
        before_action :reset_security_policy_document_page, only: :show, if: -> { @page_name == :contract_details }
        before_action :delete_incomplete_pension_data, only: :show, if: -> { @page_name == :contract_details && pension_data_incomplete? }
        before_action :create_contact_detail, only: :edit
        before_action :create_first_pension_fund, only: :edit, if: -> { @page_name == :pension_funds }

        def show; end

        def edit; end

        def update
          case @page_name
          when :pricing, :what_next, :important_information
            continue_da_journey
          when :contract_details
            validate_contract_details
          when :review_and_generate
            route_review_and_generate
          when :review
            route_review
          when :sending
            route_sending
          when :pension_funds
            update_pension_funds
          else
            update_contract_details
          end
        end

        private

        def set_procurement
          @procurement = current_user.procurements.find(params[:id] || params[:procurement_id])
        end

        def redirect_if_not_da_draft
          redirect_to facilities_management_rm3830_procurement_path(id: @procurement.id) unless @procurement.da_draft?
        end

        def redirect_if_not_in_contract_details
          redirect_to facilities_management_rm3830_procurement_contract_details_path unless @procurement.contract_details?
        end

        def return_to_results
          @procurement.return_to_results!
          redirect_to facilities_management_rm3830_procurement_path(@procurement)
        end

        def continue_da_journey
          @procurement.move_to_next_da_step
          redirect_to facilities_management_rm3830_procurement_contract_details_path
        end

        def validate_contract_details
          if @procurement.valid?(:contract_details)
            continue_da_journey
          else
            initialize_page_description_from_view_name
            render :show
          end
        end

        def route_review_and_generate
          if params[:change_requirements].present?
            @procurement.set_state_to_detailed_search!
            redirect_to facilities_management_rm3830_procurement_path(@procurement)
          elsif params[:change_contract_details].present?
            @procurement.update(da_journey_state: :contract_details)
            redirect_to facilities_management_rm3830_procurement_contract_details_path
          else
            continue_da_journey
          end
        end

        def route_review
          if params['return_to_review_and_generate'].present?
            @procurement.update(da_journey_state: :review_and_generate)
            redirect_to facilities_management_rm3830_procurement_contract_details_path
          else
            continue_da_journey
          end
        end

        def route_sending
          if params['return_to_review'].present?
            @procurement.update(da_journey_state: :review)
            redirect_to facilities_management_rm3830_procurement_contract_details_path
          else
            @procurement.move_to_next_da_step
            @procurement.set_state_to_direct_award!
            redirect_to facilities_management_rm3830_procurement_contract_sent_index_path(@procurement.id, contract_id: @procurement.procurement_suppliers.first.id)
          end
        end

        def update_contract_details
          @procurement.assign_attributes(procurement_params)

          if @procurement.save(context: @page_name)
            route_after_update
          else
            initialize_page_description_from_view_name
            render :edit
          end
        end

        def route_after_update
          case @page_name
          when :local_government_pension_scheme
            route_local_government_pension_scheme
          when :invoicing_contact_details, :authorised_representative, :notices_contact_details
            route_new_contact_detail
          when :new_invoicing_contact_details, :new_authorised_representative, :new_notices_contact_details
            redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(page: @page_name[4..])
          when :new_invoicing_contact_details_address, :new_authorised_representative_address, :new_notices_contact_details_address
            redirect_to facilities_management_rm3830_procurement_contract_details_edit_path(page: @page_name[0..-9])
          else
            redirect_to facilities_management_rm3830_procurement_contract_details_path
          end
        end

        def route_local_government_pension_scheme
          @procurement.local_government_pension_scheme ? redirect_to(facilities_management_rm3830_procurement_contract_details_edit_path(page: 'pension_funds')) : redirect_to(facilities_management_rm3830_procurement_contract_details_path)
        end

        def route_new_contact_detail
          if !using_buyer_detail_for_contact? && !contact_detail_exists?
            redirect_to(facilities_management_rm3830_procurement_contract_details_edit_path(page: "new_#{@page_name}"))
          else
            redirect_to(facilities_management_rm3830_procurement_contract_details_path)
          end
        end

        def using_buyer_detail_for_contact?
          case @page_name
          when :invoicing_contact_details
            @procurement.using_buyer_detail_for_invoice_details
          when :authorised_representative
            @procurement.using_buyer_detail_for_authorised_detail
          when :notices_contact_details
            @procurement.using_buyer_detail_for_notices_detail
          end
        end

        def contact_detail_exists?
          case @page_name
          when :invoicing_contact_details
            @procurement.invoice_contact_detail.present?
          when :authorised_representative
            @procurement.authorised_contact_detail.present?
          when :notices_contact_details
            @procurement.notices_contact_detail.present?
          end
        end

        def create_contact_detail
          case @page_name
          when :new_invoicing_contact_details, :new_invoicing_contact_details_address
            create_contact_data('invoice_contact_detail')
          when :new_authorised_representative, :new_authorised_representative_address
            create_contact_data('authorised_contact_detail')
          when :new_notices_contact_details, :new_notices_contact_details_address
            create_contact_data('notices_contact_detail')
          end
        end

        def create_contact_data(contact)
          @procurement.send("build_#{contact}") if @procurement.send(contact).blank?
        end

        def create_first_pension_fund
          @procurement.procurement_pension_funds.build if @procurement.procurement_pension_funds.empty?
        end

        def update_pension_funds
          pension_funds = procurement_params[:procurement_pension_funds_attributes]
          updated_pension_funds = {}
          pension_funds.each do |pf|
            if pf[1]['_destroy'] == 'true' && !pf[1]['id'].nil?
              @procurement.update(procurement_pension_funds_attributes: pf[1])
            else
              updated_pension_funds[pf[0]] = pf[1]
            end
          end

          @procurement.reload
          if @procurement.update(procurement_pension_funds_attributes: updated_pension_funds)
            redirect_to facilities_management_rm3830_procurement_contract_details_path
          else
            initialize_page_description_from_view_name
            render :edit
          end
        end

        def delete_incomplete_contact_details
          reset_contact_data_if_needed(:new_invoicing_contact_details, :new_invoicing_contact_details_address, :invoice_contact_detail, :using_buyer_detail_for_invoice_details)
          reset_contact_data_if_needed(:new_authorised_representative, :new_authorised_representative_address, :authorised_contact_detail, :using_buyer_detail_for_authorised_detail)
          reset_contact_data_if_needed(:new_notices_contact_details, :new_notices_contact_details_address, :notices_contact_detail, :using_buyer_detail_for_notices_detail)
        end

        # rubocop:disable Style/GuardClause
        def reset_contact_data_if_needed(new_contact, contact_address, contact_detail, using_buyer_detail)
          return if @page_name == new_contact || @page_name == contact_address

          if @procurement.contract_detail_incomplete?(contact_detail)
            @procurement.send(contact_detail).delete
            @procurement.reload
          end

          if @procurement[using_buyer_detail] == false && @procurement.send(contact_detail).blank?
            @procurement[using_buyer_detail] = nil
            @procurement.save
          end
        end
        # rubocop:enable Style/GuardClause

        def reset_security_policy_document_page
          @procurement.update(security_policy_document_required: nil) if @procurement.security_policy_document_required == true && @procurement.security_policy_document_file.attachment.nil?
        end

        def pension_data_incomplete?
          @procurement.local_government_pension_scheme ? @procurement.procurement_pension_funds.empty? : false
        end

        def delete_incomplete_pension_data
          @procurement.procurement_pension_funds.delete
          @procurement.update(local_government_pension_scheme: nil)
          @procurement.reload
        end

        def procurement_params
          params.require(:facilities_management_rm3830_procurement).permit(*PAGE_PERMITTED_PARAMS[@page_name])
        end

        PAGE_PERMITTED_PARAMS = {
          payment_method: [:payment_method],
          invoicing_contact_details: [:using_buyer_detail_for_invoice_details],
          new_invoicing_contact_details: [invoice_contact_detail_attributes: %i[id name job_title email organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode]],
          new_invoicing_contact_details_address: [invoice_contact_detail_attributes: %i[id organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode]],
          authorised_representative: [:using_buyer_detail_for_authorised_detail],
          new_authorised_representative: [authorised_contact_detail_attributes: %i[id name job_title email organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode telephone_number]],
          new_authorised_representative_address: [authorised_contact_detail_attributes: %i[id organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode telephone_number]],
          notices_contact_details: [:using_buyer_detail_for_notices_detail],
          new_notices_contact_details: [notices_contact_detail_attributes: %i[id name job_title email organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode]],
          new_notices_contact_details_address: [notices_contact_detail_attributes: %i[id organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode]],
          security_policy_document: %i[security_policy_document_required security_policy_document_name security_policy_document_version_number security_policy_document_date_dd security_policy_document_date_mm security_policy_document_date_yyyy security_policy_document_file],
          local_government_pension_scheme: [:local_government_pension_scheme],
          pension_funds: [procurement_pension_funds_attributes: %i[id name percentage _destroy case_sensitive_error]],
          governing_law: [:governing_law]
        }.freeze

        def set_page_name
          @page_name = if action_name == 'show'
                         @procurement.da_journey_state.to_sym
                       else
                         params[:page].to_sym
                       end
        end

        def redirect_if_unrecognised_page_name
          redirect_to facilities_management_rm3830_procurement_contract_details_path unless RECOGNISED_PAGE_NAMES.include? @page_name
        end

        RECOGNISED_PAGE_NAMES = %i[authorised_representative governing_law invoicing_contact_details local_government_pension_scheme new_authorised_representative_address new_authorised_representative new_invoicing_contact_details_address new_invoicing_contact_details new_notices_contact_details_address new_notices_contact_details notices_contact_details payment_method pension_funds security_policy_document].freeze

        protected

        def authorize_user
          authorize! :manage, @procurement
        end
      end
    end
  end
end
