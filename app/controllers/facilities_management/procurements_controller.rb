require 'facilities_management/fm_buildings_data'
require 'rubygems'

module FacilitiesManagement
  class ProcurementsController < FacilitiesManagement::FrameworkController
    before_action :set_procurement, only: %i[show edit update destroy results]
    before_action :set_deleted_action_occurred, only: %i[index]
    before_action :set_edit_state, only: %i[index show edit update destroy]
    before_action :ready_buildings, only: %i[show edit update]
    before_action :set_procurement_data, only: %i[show edit update results]
    before_action :set_new_procurement_data, only: %i[new]
    before_action :procurement_valid?, only: :show, if: -> { params[:validate].present? }
    before_action :build_page_details, only: %i[show edit update destroy results]

    def index
      @searches = current_user.procurements.where(aasm_state: FacilitiesManagement::Procurement::SEARCH).order(updated_at: :asc).sort_by { |search| FacilitiesManagement::Procurement::SEARCH_ORDER.index(search.aasm_state) }
      @in_draft = current_user.procurements.da_draft.order(updated_at: :asc)
      @sent_offers = sent_offers
      @contracts = live_contracts
      @closed_contracts = closed_contracts
      @further_competition_contracts = current_user.procurements.further_competition.order(updated_at: :asc)
    end

    def show
      redirect_to edit_facilities_management_procurement_url(id: @procurement.id, delete: @delete) if @procurement.quick_search? && @delete
      redirect_to edit_facilities_management_procurement_url(id: @procurement.id) if @procurement.quick_search? && !@delete

      @view_name = set_view_data unless @procurement.quick_search?
      reset_security_policy_document_page
    end

    def new
      @procurement = current_user.procurements.build(service_codes: params[:service_codes], region_codes: params[:region_codes])
      @back_path = helpers.journey_step_url_former(journey_step: 'locations', region_codes: params[:region_codes], service_codes: params[:service_codes])
    end

    def create
      @procurement = current_user.procurements.build(procurement_params)

      if @procurement.save(context: :contract_name)
        redirect_to edit_facilities_management_procurement_url(id: @procurement.id)
      else
        @errors = @procurement.errors
        set_procurement_data
        @back_path = helpers.journey_step_url_former(journey_step: 'locations', region_codes: @procurement.region_codes, service_codes: @procurement.service_codes)
        render :new
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
    def edit
      if @procurement.quick_search?
        render :edit
      else
        @back_link = FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, procurement_state: @procurement.aasm_state, step: nil).back_link

        unless FacilitiesManagement::ProcurementRouter::STEPS.include?(params[:step]) && @procurement.aasm_state == 'da_draft'
          # da journey follows
          @view_name = set_view_data unless @procurement.quick_search?
          render @view_da && return
        end

        redirect_to facilities_management_procurement_url(id: @procurement.id) && return unless FacilitiesManagement::ProcurementRouter::STEPS.include?(params[:step])
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def update
      change_the_contract_value && return if params['change_the_contract_value'].present?

      continue_to_summary && return if params['change_requirements'].present?

      continue_to_results && return if params['continue_to_results'].present?

      continue_from_change_contract_value && return if params['continue_from_change_contract_value'].present?

      set_route_to_market && return if params['set_route_to_market'].present?

      change_contract_details && return if params['change_contract_details'].present?

      continue_to_review_and_generate && return if params['continue_to_review_and_generate'].present?

      return_to_review_contract && return if params['return_to_review_contract'].present?

      continue_to_procurement_pensions && return if params.dig('facilities_management_procurement', 'step') == 'local_government_pension_scheme'

      update_pension_funds && return if params.dig('facilities_management_procurement', 'step') == 'pension_funds'

      continue_to_new_invoice && return if params.dig('facilities_management_procurement', 'step') == 'invoicing_contact_details' && params.dig('facilities_management_procurement', 'using_buyer_detail_for_invoice_details') == 'false'

      continue_to_new_invoice_from_add_address && return if params.dig('facilities_management_procurement', 'step') == 'new_invoicing_address'

      continue_to_invoice_from_new_invoice && return if params.dig('facilities_management_procurement', 'step') == 'new_invoicing_contact_details'

      continue_to_new_authorised && return if params.dig('facilities_management_procurement', 'step') == 'authorised_representative' && params.dig('facilities_management_procurement', 'using_buyer_detail_for_authorised_detail') == 'false'

      continue_to_new_authorised_from_add_address && return if params.dig('facilities_management_procurement', 'step') == 'new_authorised_representative_address'

      continue_to_authorised_from_new_authorised && return if params.dig('facilities_management_procurement', 'step') == 'new_authorised_representative_details'

      continue_to_new_notices && return if params.dig('facilities_management_procurement', 'step') == 'notices_contact_details' && params.dig('facilities_management_procurement', 'using_buyer_detail_for_notices_detail') == 'false'

      continue_to_new_notices_from_add_address && return if params.dig('facilities_management_procurement', 'step') == 'new_notices_address'

      continue_to_notices_from_new_notices && return if params.dig('facilities_management_procurement', 'step') == 'new_notices_contact_details'

      update_service_codes && return if params.dig('facilities_management_procurement', 'step') == 'services'

      update_region_codes && return if params.dig('facilities_management_procurement', 'step') == 'regions'

      update_procurement && return if params['facilities_management_procurement'].present?

      continue_da_journey if params['continue_da'].present?
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize

    # DELETE /procurements/1
    # DELETE /procurements/1.json
    def destroy
      @procurement.destroy

      respond_to do |format|
        format.html { redirect_to facilities_management_procurements_url(deleted: @procurement.contract_name) }
        format.json { head :no_content }
      end
    end

    def further_competition_spreadsheet
      init
      spreadsheet_builder = FacilitiesManagement::FurtherCompetitionSpreadsheetCreator.new(@procurement.id)
      spreadsheet_builder.build
      send_data spreadsheet_builder.to_xlsx, filename: 'further_competition_procurement_summary.xlsx', type: 'application/vnd.ms-excel'
    end

    def summary
      @page_data = {}
      @page_data[:model_object] = @procurement
    end

    def results
      redirect_to(facilities_management_procurement_path(@procurement)) && return unless verify_status('results')

      set_results_page_data
      @procurement[:route_to_market] = @procurement.aasm_state
    end

    def da_spreadsheets
      init
      if params[:spreadsheet] == 'prices_spreadsheet'
        spreadsheet1 = FacilitiesManagement::DirectAwardSpreadsheet.new @procurement.first_unsent_contract.id
        render xlsx: spreadsheet1.to_xlsx, filename: 'direct_award_prices'
      else
        spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new @procurement.first_unsent_contract.id
        spreadsheet2 = spreadsheet_builder.build
        render xlsx: spreadsheet2.to_stream.read, filename: 'deliverable_matrix'
      end
    end

    private

    def init
      @procurement = current_user.procurements.find_by(id: params[:procurement_id])
    end

    def init_further_competition
      if params[:procurement_id]
        @procurement = current_user.procurements.where(id: params[:procurement_id]).first
        @start_date = @procurement[:initial_call_off_start_date]
      else
        @start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      end
    end

    # rubocop:disable Metrics/AbcSize
    def set_view_data
      set_current_step
      view_name = if !params[:step].nil? && FacilitiesManagement::ProcurementRouter::DA_JOURNEY_STATES_TO_VIEWS.include?(params[:step].to_sym)
                    'edit'
                  else
                    FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, procurement_state: @procurement.aasm_state, step: params[:step]).view
                  end
      build_page_details(view_name.to_sym)

      case view_name
      when 'results'
        set_results_page_data
        @procurement[:route_to_market] = @procurement.aasm_state
      when 'direct_award', 'edit'
        @view_da = FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, procurement_state: nil, da_journey_state: @procurement.da_journey_state, step: params['step']).da_journey_view
        create_da_buyer_page_data(@view_da)
      else
        @page_data = {}
        @procurement_reference = @procurement.contract_number
        @page_data[:model_object] = @procurement
      end

      contract_value_page_details if @procurement.aasm_state == 'choose_contract_value'

      view_name
    end
    # rubocop:enable Metrics/AbcSize

    def update_procurement
      assign_procurement_parameters
      if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
        @procurement.start_detailed_search! if @procurement.quick_search? && params['start_detailed_search'].present?
        @procurement.reload

        set_current_step

        redirect_to FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, procurement_state: @procurement.aasm_state, step: @current_step).route
      else
        remove_invalid_security_policy_document_file
        set_step_param
        @view_name = set_view_data unless @procurement.quick_search?

        set_da_journey_render
        render :edit
      end
    end

    def remove_invalid_security_policy_document_file
      # This is so that activestorage destroys invalid files. Proper validations will come with Rails 6, but
      # for now, this is the best, albeit ugliest, workaround. User will lose their original security policy document
      # if trying to replace it with an invalid one.
      return nil unless @procurement.errors[:security_policy_document_file].any?

      @procurement.reload.security_policy_document_file.purge
      @procurement.assign_attributes(procurement_params.except(:security_policy_document_file))
    end

    def reset_security_policy_document_page
      @procurement.security_policy_document_required = nil if @procurement.security_policy_document_required == true && @procurement.security_policy_document_file.attachment.nil?
    end

    def set_da_journey_render
      create_da_buyer_page_data(params[:step]) if FacilitiesManagement::ProcurementRouter::DA_JOURNEY_STATES_TO_VIEWS.key?(params[:step]&.to_sym)
    end

    def assign_procurement_parameters
      @procurement.assign_attributes(procurement_params)

      # To need to do this is awful - it will trigger validations so that an invalid action can be recognised
      # that action - resulting in clearing the service_code collection in the store will not happen
      # we can however validate and push the custom message to the client from here
      # !WHY?! The browser is not sending the [:facilities_management_procurement][:service_codes] value as empty
      #        if no checkboxes are checked
      #        Can the procurement_params specification not establish defaults?
      @procurement.service_codes = [] if params[:facilities_management_procurement][:step].try(:to_sym) == :services && params[:facilities_management_procurement][:service_codes].nil?
    end

    def verify_status(status)
      if status == 'results'
        return false if %w[quick_search detailed_search].include?(@procurement.aasm_state.downcase)

        return true
      end

      @procurement.aasm_state.to_sym == status.to_sym
    end

    def change_the_contract_value
      @procurement.set_state_to_choose_contract_value!
      redirect_to facilities_management_procurement_path(@procurement)
    end

    def continue_to_summary
      @procurement.set_state_to_detailed_search
      @procurement.save
      redirect_to facilities_management_procurement_path(@procurement)
    end

    def continue_to_results
      if procurement_valid?
        @procurement.set_state_to_results_if_possible!
        redirect_to facilities_management_procurement_path(@procurement)
      else
        redirect_to facilities_management_procurement_path(@procurement, validate: true)
      end
    end

    def continue_from_change_contract_value
      @procurement.assign_attributes(procurement_params)
      if @procurement.valid?(:choose_contract_value)
        @procurement.set_state_to_results!
        redirect_to facilities_management_procurement_path(@procurement)
      else
        @view_name = set_view_data
        render :show
      end
    end

    def change_contract_details
      @procurement.update(da_journey_state: :contract_details)
      redirect_to facilities_management_procurement_path(@procurement)
    end

    def continue_to_review_and_generate
      if @procurement.valid?(:contract_details)
        @procurement.update(da_journey_state: :review_and_generate)
        redirect_to facilities_management_procurement_path(@procurement)
      else
        @view_name = set_view_data
        render :show
      end
    end

    def return_to_review_contract
      @procurement.update(da_journey_state: :review)
      redirect_to facilities_management_procurement_path(@procurement)
    end

    def continue_to_contract_details
      if procurement_valid?
        @procurement.set_to_contract_details
        @procurement.save
        redirect_to facilities_management_procurement_path(@procurement)
      else
        redirect_to facilities_management_procurement_path(@procurement, validate: true)
      end
    end

    def continue_da_journey
      if procurement_valid?
        @procurement.move_to_next_da_step
        @procurement.save
        send_contract && return if @procurement.da_journey_state == 'sent'
        redirect_to facilities_management_procurement_path(@procurement)
      else
        redirect_to facilities_management_procurement_path(@procurement, validate: true)
      end
    end

    def send_contract
      @procurement.set_state_to_direct_award!
      redirect_to facilities_management_procurement_contract_sent_index_path(@procurement.id, contract_id: @procurement.procurement_suppliers.first.id)
    end

    def continue_to_procurement_pensions
      @procurement.assign_attributes(procurement_params)
      if @procurement.valid?(:local_government_pension_scheme)
        @procurement.save
        if @procurement.local_government_pension_scheme
          @procurement.procurement_pension_funds.build if @procurement.procurement_pension_funds.empty?
          params[:step] = 'pension_funds'
          create_da_buyer_page_data('pension_funds')
          render :edit
        else
          redirect_to facilities_management_procurement_path(id: @procurement.id)
        end
      else
        set_step_param
        create_da_buyer_page_data('local_government_pension_scheme')
        render :edit
      end
    end

    def update_service_codes
      @procurement.update(service_codes: procurement_params[:service_codes])
      if @procurement.quick_search?
        redirect_to edit_facilities_management_procurement_path(id: @procurement.id)
      else
        redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: :building_services) && return if params['next_step'].present?
        redirect_to facilities_management_procurement_path(@procurement)
      end
    end

    def update_region_codes
      @procurement.update(region_codes: procurement_params[:region_codes])
      redirect_to edit_facilities_management_procurement_path(id: @procurement.id)
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
        redirect_to facilities_management_procurement_path(id: @procurement.id)
      else
        set_step_param
        create_da_buyer_page_data('pension_funds')
        render :edit
      end
    end

    def continue_to_new_invoice
      @procurement.assign_attributes(procurement_params)

      return if @procurement.using_buyer_detail_for_invoice_details

      redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_invoicing_contact_details') if !@procurement.using_buyer_detail_for_invoice_details && @procurement.invoice_contact_detail.blank?
    end

    def continue_to_new_invoice_from_add_address
      assign_procurement_parameters
      if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
        redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_invoicing_contact_details')
      else
        create_da_buyer_page_data(params[:facilities_management_procurement][:step].try(:to_sym))
        set_step_param
        render :edit
      end
    end

    def continue_to_invoice_from_new_invoice
      assign_procurement_parameters
      @procurement.assign_attributes(using_buyer_detail_for_invoice_details: false)
      if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
        redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'invoicing_contact_details')
      else
        create_da_buyer_page_data(params[:facilities_management_procurement][:step].try(:to_sym))
        set_step_param
        render :edit
      end
    end

    def continue_to_new_authorised
      @procurement.assign_attributes(procurement_params)

      return if @procurement.using_buyer_detail_for_authorised_detail

      redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_authorised_representative_details') if !@procurement.using_buyer_detail_for_authorised_detail && @procurement.authorised_contact_detail.blank?
    end

    def continue_to_new_authorised_from_add_address
      assign_procurement_parameters
      if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
        redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_authorised_representative_details')
      else
        create_da_buyer_page_data(params[:facilities_management_procurement][:step].try(:to_sym))
        set_step_param
        render :edit
      end
    end

    def continue_to_authorised_from_new_authorised
      assign_procurement_parameters
      @procurement.assign_attributes(using_buyer_detail_for_authorised_detail: false)
      if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
        redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'authorised_representative')
      else
        create_da_buyer_page_data(params[:facilities_management_procurement][:step].try(:to_sym))
        set_step_param
        render :edit
      end
    end

    def continue_to_new_notices
      @procurement.assign_attributes(procurement_params)

      return if @procurement.using_buyer_detail_for_notices_detail

      redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_notices_contact_details') if !@procurement.using_buyer_detail_for_notices_detail && @procurement.notices_contact_detail.blank?
    end

    def continue_to_new_notices_from_add_address
      assign_procurement_parameters
      if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
        redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_notices_contact_details')
      else
        create_da_buyer_page_data(params[:facilities_management_procurement][:step].try(:to_sym))
        set_step_param
        render :edit
      end
    end

    def continue_to_notices_from_new_notices
      assign_procurement_parameters
      @procurement.assign_attributes(using_buyer_detail_for_notices_detail: false)
      if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
        redirect_to edit_facilities_management_procurement_path(id: @procurement.id, step: 'notices_contact_details')
      else
        create_da_buyer_page_data(params[:facilities_management_procurement][:step].try(:to_sym))
        set_step_param
        render :edit
      end
    end

    def contract_value_page_details
      @page_details[:unpriced_services] = @procurement.procurement_building_services_not_used_in_calculation
    end

    # sets the state of the procurement depending on the submission from the results view
    def set_route_to_market
      if params[:commit] == page_details(:results)[:secondary_text]
        @procurement.set_state_to_detailed_search
        @procurement.save

        redirect_to facilities_management_procurement_path(@procurement)
        return
      end

      @procurement.assign_attributes(procurement_route_params)

      unless @procurement.valid?(:route_to_market)
        build_page_details(:results)
        set_results_page_data
        render 'results'
        return true
      end

      @procurement.start_direct_award if @procurement[:route_to_market] == 'da_draft'
      @procurement.start_further_competition if @procurement[:route_to_market] == 'further_competition'
      @procurement.save

      redirect_to facilities_management_procurement_path(@procurement)
    end

    def set_results_page_data
      @page_data = {}
      @page_data[:model_object] = @procurement
      @page_data[:no_suppliers] = @procurement.procurement_suppliers.count
      @page_data[:supplier_collection] = @procurement.procurement_suppliers.map { |s| s.supplier.data['supplier_name'] }.shuffle
      @page_data[:estimated_cost] = @procurement.assessed_value
      @page_data[:selected_sublot] = @procurement.lot_number
      @page_data[:buildings] = @active_procurement_buildings.map { |b| b[:name] }
      @page_data[:services] = @procurement.procurement_building_services.map { |s| s[:name] }
      @page_data[:supplier_prices] = @procurement.procurement_suppliers.map(&:direct_award_value)
    end

    def create_da_buyer_page_data(view_name)
      @page_data = {}
      build_da_journey_page_details(view_name)
      @page_data[:model_object] = @procurement
      @page_data[:no_suppliers] = @procurement.procurement_suppliers.count
      @page_data[:sorted_supplier_list] = @procurement.procurement_suppliers.where(direct_award_value: FacilitiesManagement::Procurement::DIRECT_AWARD_VALUE_RANGE).map { |i| { price: i[:direct_award_value], name: i.supplier['data']['supplier_name'] } }
      contact_details_data_setup(params[:step])
      verify_completed_contact_details(params[:step])
    end

    def contact_details_data_setup(step)
      return if step.nil?

      case step
      when 'new_invoicing_contact_details', 'new_invoicing_address'
        set_invoice_data
      when 'new_authorised_representative_details', 'new_authorised_representative_address'
        set_authorised_data
      when 'new_notices_contact_details', 'new_notices_address'
        set_notices_data
      end
    end

    # rubocop:disable Style/GuardClause
    def verify_completed_contact_details(step)
      if delete_pension_data? step
        @procurement.procurement_pension_funds.delete
        @procurement.update(local_government_pension_scheme: nil)
        @procurement.reload
      end

      return if step.nil?

      if delete_invoice_data? step
        @procurement.invoice_contact_detail.delete
        @procurement.reload
      end
      if delete_authorised_data? step
        @procurement.authorised_contact_detail.delete
        @procurement.reload
      end
      if delete_notices_data? step
        @procurement.notices_contact_detail.delete
        @procurement.reload
      end
    end
    # rubocop:enable Style/GuardClause

    def set_invoice_data
      @procurement.build_invoice_contact_detail if @procurement.invoice_contact_detail.blank?
    end

    def set_authorised_data
      @procurement.build_authorised_contact_detail if @procurement.authorised_contact_detail.blank?
    end

    def set_notices_data
      @procurement.build_notices_contact_detail if @procurement.notices_contact_detail.blank?
    end

    def delete_invoice_data?(step)
      case step
      when 'new_invoicing_contact_details', 'new_invoicing_address'
        false
      else
        !@procurement.invoice_contact_detail.nil? && @procurement.invoice_contact_detail.name.nil?
      end
    end

    def delete_authorised_data?(step)
      case step
      when 'new_authorised_representative_details', 'new_authorised_representative_address'
        false
      else
        !@procurement.authorised_contact_detail.nil? && @procurement.authorised_contact_detail.name.nil?
      end
    end

    def delete_notices_data?(step)
      case step
      when 'new_notices_contact_details', 'new_notices_address'
        false
      else
        !@procurement.notices_contact_detail.nil? && @procurement.notices_contact_detail.name.nil?
      end
    end

    def delete_pension_data?(step)
      return false unless @procurement.local_government_pension_scheme

      case step
      when 'local_government_pension_scheme', 'pension_funds'
        false
      else
        @procurement.procurement_pension_funds.empty?
      end
    end

    def contracts(state)
      current_user.procurements.direct_award.map { |procurement| procurement.public_send(state) }&.flatten
    end

    def sent_offers
      current_user.procurements.direct_award&.map(&:sent_offers)&.flatten&.sort_by { |each| [FacilitiesManagement::ProcurementSupplier::SENT_OFFER_ORDER.index(each.aasm_state), each.offer_sent_date] }
    end

    def live_contracts
      current_user.procurements.direct_award.map(&:live_contracts)&.flatten&.sort_by(&:contract_signed_date)
    end

    def closed_contracts
      current_user.procurements.where(aasm_state: ['direct_award', 'closed']).map(&:closed_contracts)&.flatten&.sort_by { |sent_offer| sent_offer.contract_closed_date }&.reverse
    end

    def procurement_route_params
      params.require(:facilities_management_procurement).permit(:route_to_market)
    end

    # rubocop:disable Metrics/MethodLength
    def procurement_params
      params.require(:facilities_management_procurement)
            .permit(
              :tupe,
              :contract_name,
              :procurement_data,
              :estimated_annual_cost,
              :estimated_cost_known,
              :initial_call_off_start_date_dd,
              :initial_call_off_start_date_mm,
              :initial_call_off_start_date_yyyy,
              :initial_call_off_period,
              :mobilisation_period,
              :optional_call_off_extensions_1,
              :optional_call_off_extensions_2,
              :optional_call_off_extensions_3,
              :optional_call_off_extensions_4,
              :call_off_extension_2,
              :call_off_extension_3,
              :call_off_extension_4,
              :mobilisation_period_required,
              :extensions_required,
              :security_policy_document_required,
              :security_policy_document_name,
              :security_policy_document_version_number,
              :security_policy_document_date_dd,
              :security_policy_document_date_mm,
              :security_policy_document_date_yyyy,
              :security_policy_document_file,
              :payment_method,
              :using_buyer_detail_for_invoice_details,
              :using_buyer_detail_for_authorised_detail,
              :using_buyer_detail_for_notices_detail,
              :local_government_pension_scheme,
              :lot_number,
              :lot_number_selected_by_customer,
              service_codes: [],
              region_codes: [],
              procurement_buildings_attributes: [:id,
                                                 :name,
                                                 :address_line_1,
                                                 :address_line_2,
                                                 :town,
                                                 :county,
                                                 :postcode,
                                                 :active,
                                                 service_codes: []],
              procurement_pension_funds_attributes: %i[id name percentage _destroy case_sensitive_error],
              invoice_contact_detail_attributes: %i[id name job_title email organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode],
              authorised_contact_detail_attributes: %i[id name job_title email organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode telephone_number],
              notices_contact_detail_attributes: %i[id name job_title email organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode]
            )
    end
    # rubocop:enable Metrics/MethodLength

    def set_current_step
      @current_step = nil
      @current_step ||= params[:facilities_management_procurement][:step] if params['next_step'].present?
    end

    def set_procurement
      @procurement = Procurement.find(params[:id] || params[:procurement_id])
    end

    def set_new_procurement_data
      set_suppliers(params[:region_codes], params[:service_codes])
      find_regions(params[:region_codes])
      find_services(params[:service_codes])
    end

    def set_procurement_data
      region_codes = @procurement.region_codes
      service_codes = @procurement.service_codes
      set_suppliers(region_codes, service_codes)
      find_regions(region_codes)
      find_services(service_codes)
      @active_procurement_buildings = @procurement.procurement_buildings.try(:active)
      set_buildings if params['step'] == 'procurement_buildings'
    end

    def set_suppliers(region_codes, service_codes)
      @suppliers_lot1a = CCS::FM::Supplier.long_list_suppliers_lot(region_codes, service_codes, '1a')
      @suppliers_lot1b = CCS::FM::Supplier.long_list_suppliers_lot(region_codes, service_codes, '1b')
      @suppliers_lot1c = CCS::FM::Supplier.long_list_suppliers_lot(region_codes, service_codes, '1c')
      @supplier_count = CCS::FM::Supplier.supplier_count(region_codes, service_codes)
    end

    def set_buildings
      @buildings_data = current_user.buildings.where(status: 'Ready')
      @buildings_data.each do |building|
        @procurement.find_or_build_procurement_building(building['building_json'], building.id)
      end
    end

    def find_regions(region_codes)
      @regions = FacilitiesManagement::Region.where(code: region_codes)
    end

    def find_services(service_codes)
      @services = Service.where(code: service_codes)
    end

    def set_step_param
      params[:step] = params[:facilities_management_procurement][:step] unless @procurement.quick_search?
    end

    def ready_buildings
      @building_count = FacilitiesManagement::Building.where(user_id: current_user.id, status: 'Ready').size
    end

    def set_deleted_action_occurred
      @deleted = params[:deleted].present?
      @what_was_deleted = params[:deleted].to_s.downcase if @deleted
    end

    def set_edit_state
      @delete = params[:delete] == 'y' || params[:delete] == 'true'
      @change = !@delete && action_name == 'edit'
    end

    def procurement_valid?
      @procurement.valid_on_continue?
    end

    def set_results_page_definitions
      page_definitions = {
        caption1: @procurement[:contract_name],
        continuation_text: 'Continue',
        return_url: facilities_management_procurements_path,
        return_text: 'Return to procurement dashboard',
        back_text: 'Back',
        back_url: facilities_management_procurements_path,
        page_title: 'Results',
        primary_name: 'set_route_to_market',
        secondary_name: 'change_requirements',
        secondary_text: 'Change requirements',
        secondary_url: facilities_management_procurements_path
      }
      if @procurement.lot_number_selected_by_customer
        page_definitions[:secondary_name] = 'change_the_contract_value'
        page_definitions[:secondary_url] = facilities_management_procurements_path
        page_definitions[:secondary_text] = 'Change contract value'
      end
      page_definitions
    end

    # used to control page navigation and headers
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Style/MultilineIfModifier
    def build_page_details(action = nil)
      action = action_name if action.nil?

      @page_data = {}
      @page_description = LayoutHelper::PageDescription.new(
        LayoutHelper::HeadingDetail.new(page_details(action)[:page_title],
                                        page_details(action)[:caption1],
                                        page_details(action)[:caption2],
                                        page_details(action)[:sub_title],
                                        page_details(action)[:caption3]),
        LayoutHelper::BackButtonDetail.new(page_details(action)[:back_url],
                                           page_details(action)[:back_label],
                                           page_details(action)[:back_text]),
        LayoutHelper::NavigationDetail.new(page_details(action)[:continuation_text],
                                           page_details(action)[:return_url],
                                           page_details(action)[:return_text],
                                           page_details(action)[:secondary_url],
                                           page_details(action)[:secondary_text],
                                           page_details(action)[:primary_name],
                                           page_details(action)[:secondary_name])
      ) if page_definitions.key?(action.to_sym)
    end

    def build_da_journey_page_details(view_name)
      @page_description = LayoutHelper::PageDescription.new(
        LayoutHelper::HeadingDetail.new(da_journey_page_details(view_name.to_sym)[:page_title],
                                        da_journey_page_details(view_name.to_sym)[:caption1],
                                        da_journey_page_details(view_name.to_sym)[:caption2],
                                        da_journey_page_details(view_name.to_sym)[:sub_title],
                                        da_journey_page_details(view_name.to_sym)[:caption3]),
        LayoutHelper::BackButtonDetail.new(da_journey_page_details(view_name.to_sym)[:back_url],
                                           da_journey_page_details(view_name.to_sym)[:back_label],
                                           da_journey_page_details(view_name.to_sym)[:back_text]),
        LayoutHelper::NavigationDetail.new(da_journey_page_details(view_name.to_sym)[:continuation_text],
                                           da_journey_page_details(view_name.to_sym)[:return_url],
                                           da_journey_page_details(view_name.to_sym)[:return_text],
                                           da_journey_page_details(view_name.to_sym)[:secondary_url],
                                           da_journey_page_details(view_name.to_sym)[:secondary_text],
                                           da_journey_page_details(view_name.to_sym)[:primary_name],
                                           da_journey_page_details(view_name.to_sym)[:secondary_name])
      ) if da_journey_definitions.key?(view_name.to_sym)
    end
    # rubocop:enable Style/MultilineIfModifier
    # rubocop:enable Metrics/AbcSize

    def da_journey_page_details(view_name)
      @page_details = {} if @page_details.nil?

      @da_journey_page_details ||= @page_details.merge(da_journey_definitions[:default].merge(da_journey_definitions[view_name.to_sym]))
    end

    def page_details(action)
      @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def da_journey_definitions
      @da_journey_definitions ||= {
        default: {
          caption1: @procurement[:contract_name],
          continuation_text: 'Continue',
          return_url: facilities_management_procurements_path,
          return_text: 'Return to procurement dashboard',
          secondary_name: 'change_requirements',
          secondary_text: 'Change requirements',
          secondary_url: facilities_management_procurements_path,
          back_text: 'Back',
          back_url: facilities_management_procurements_path
        },
        contract_details: {
          page_title: 'Contract details',
          primary_name: 'continue_da',
          secondary_name: 'continue_to_results',
          secondary_text: 'Return to results'
        },
        pricing: {
          page_title: 'Direct award pricing',
          primary_name: 'continue_da',
          continuation_text: 'Continue to direct award',
          secondary_name: 'continue_to_results',
          secondary_text: 'Return to results'
        },
        what_next: {
          page_title: 'What happens next',
          primary_name: 'continue_da',
          continuation_text: 'Continue to direct award',
          secondary_name: 'continue_to_results',
          secondary_text: 'Return to results'
        },
        did_you_know: {
          page_title: 'Important information',
          primary_name: 'continue_da',
          continuation_text: 'Continue',
          secondary_name: 'continue_to_results',
          secondary_text: 'Return to results'
        },
        payment_method: {
          back_url: facilities_management_procurement_path(@procurement),
          page_title: 'Payment method',
          continuation_text: 'Save and return',
          return_text: 'Return to contract details',
          return_url: facilities_management_procurement_path(@procurement)
        },
        invoicing_contact_details: {
          back_url: facilities_management_procurement_path(@procurement),
          page_title: 'Invoicing contact details',
          continuation_text: 'Continue',
          return_text: 'Return to contract details',
          return_url: facilities_management_procurement_path(@procurement)
        },
        new_invoicing_contact_details: {
          back_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'invoicing_contact_details'),
          page_title: 'New invoicing contact details',
          continuation_text: 'Save and return',
          return_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'invoicing_contact_details'),
          return_text: 'Return to invoicing contact details',
        },
        new_invoicing_address: {
          back_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_invoicing_contact_details'),
          page_title: 'Add address',
          return_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_invoicing_contact_details'),
          return_text: 'Return to new invoicing contact details',
          caption3: @procurement[:contract_name],
          caption1: 'New invoicing contact details'
        },
        authorised_representative: {
          back_url: facilities_management_procurement_path(@procurement),
          page_title: 'Authorised representative details',
          continuation_text: 'Continue',
          return_text: 'Return to contract details',
          return_url: facilities_management_procurement_path(@procurement)
        },
        new_authorised_representative_details: {
          back_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'authorised_representative'),
          page_title: 'New authorised representative details',
          continuation_text: 'Continue',
          return_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'authorised_representative'),
          return_text: 'Return to authorised representative details',
        },
        new_authorised_representative_address: {
          back_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_authorised_representative_details'),
          page_title: 'Add address',
          return_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_authorised_representative_details'),
          return_text: 'Return to new authorised representative details',
          caption3: @procurement[:contract_name],
          caption1: 'New authorised representative details'
        },
        notices_contact_details: {
          back_url: facilities_management_procurement_path(@procurement),
          page_title: 'Notices contact details',
          continuation_text: 'Continue',
          return_text: 'Return to contract details',
          return_url: facilities_management_procurement_path(@procurement)
        },
        new_notices_contact_details: {
          back_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'notices_contact_details'),
          page_title: 'New notices contact details',
          continuation_text: 'Save and return',
          return_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'notices_contact_details'),
          return_text: 'Return to notices contact details',
        },
        new_notices_address: {
          back_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_notices_contact_details'),
          page_title: 'Add address',
          return_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'new_notices_contact_details'),
          return_text: 'Return to new notices contact details',
          caption3: @procurement[:contract_name],
          caption1: 'New notices contact details'
        },
        local_government_pension_scheme: {
          back_url: facilities_management_procurement_path(@procurement),
          page_title: 'Local Government Pension Scheme',
          continuation_text: 'Save and continue',
          return_text: 'Return to contract details',
          return_url: facilities_management_procurement_path(@procurement)
        },
        pension_funds: {
          back_url: edit_facilities_management_procurement_path(id: @procurement.id, step: 'local_government_pension_scheme'),
          page_title: 'Pension funds',
          continuation_text: 'Save and return',
          return_text: 'Return to contract details',
          return_url: facilities_management_procurement_path(@procurement)
        },
        security_policy_document: {
          page_title: t('facilities_management.procurements.edit.security_policy_document.title'),
          back_url: facilities_management_procurement_path(@procurement),
          back_text: 'Back',
          caption1: @procurement[:contract_name],
          continuation_text: 'Save and return',
          return_text: 'Return to contract details',
          return_url: facilities_management_procurement_path(@procurement)
        },
        review_and_generate_documents: {
          page_title: 'Review and generate documents',
          continuation_text: 'Generate documents',
          secondary_text: 'Return to results',
          secondary_name: 'continue_to_results'
        },
        review_contract: {
          page_title: 'Review your contract',
          continuation_text: 'Create final contract and send to supplier',
          secondary_text: 'Return to results',
          secondary_name: 'continue_to_results'
        },
        sending_the_contract: {
          page_title: 'Sending the contract',
          continuation_text: 'Confirm and send contract to supplier',
          secondary_text: 'Cancel, return to review your contract',
          secondary_name: 'return_to_review_contract'
        }
      }
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def page_definitions
      @page_definitions ||= {
        default: {
          caption1: @procurement[:contract_name],
          continuation_text: 'Continue',
          return_url: facilities_management_procurements_path,
          return_text: 'Return to procurement dashboard',
          secondary_name: 'change_requirements',
          secondary_text: 'Change requirements',
          secondary_url: facilities_management_procurements_path,
          back_text: 'Back',
          back_url: facilities_management_procurements_path
        },
        choose_contract_value: {
          page_title: 'Contract value',
          primary_name: 'continue_from_change_contract_value'
        },
        results: set_results_page_definitions,
        direct_award: {
          page_title: 'Direct Award Pricing',
          back_url: facilities_management_procurement_results_path(@procurement),
          continuation_text: 'Continue to direct award',
          secondary_text: 'Return to results',
          secondary_name: 'continue_to_results',
          primary_name: 'continue_da',
          secondary_url: facilities_management_procurement_results_path(@procurement),
        },
        further_competition: {
          page_title: 'Further competition',
          secondary_name: 'change_requirements',
          secondary_text: 'Return to results',
          continuation_text: 'Make a copy of your requirements'
        },
        summary: {
          page_title: 'Summary',
          return_url: facilities_management_procurements_path(@procurement)
        }
      }.freeze
    end
  end
end
