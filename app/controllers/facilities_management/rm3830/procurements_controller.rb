module FacilitiesManagement
  module RM3830
    class ProcurementsController < FacilitiesManagement::FrameworkController
      include FacilitiesManagement::PageDetail::RM3830::Procurements

      before_action :set_procurement, except: %i[index new create what_happens_next]
      before_action :authorize_user
      before_action :set_deleted_action_occurred, only: :index
      before_action :redirect_from_delete_if_needed, only: %i[delete destroy]
      before_action :redirect_if_missing_regions, :redirect_to_contract_details_if_da_draft, only: :show
      before_action :redirect_if_unrecognised_step, only: :edit
      before_action :procurement_valid?, only: :show, if: -> { params[:validate].present? }
      before_action :set_current_step, only: %i[show edit]
      before_action :set_view_name, only: :show
      before_action :initialize_page_description_from_view_name, only: :show, if: -> { page_definitions.key?(@view_name.to_sym) }

      def index
        @searches = current_user.rm3830_procurements.where(aasm_state: Procurement::SEARCH).order(updated_at: :asc).sort_by { |search| Procurement::SEARCH_ORDER.index(search.aasm_state) }
        @in_draft = current_user.rm3830_procurements.da_draft.order(updated_at: :asc)
        @sent_offers = sent_offers
        @contracts = live_contracts
        @closed_contracts = closed_contracts
        @further_competition_contracts = current_user.rm3830_procurements.further_competition.order(updated_at: :asc)
      end

      def show
        redirect_to facilities_management_rm3830_procurements_path if @procurement.da_journey_state == 'sent'
        redirect_to facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: @procurement, id: @procurement.spreadsheet_import) if @procurement.detailed_search_bulk_upload? && @procurement.spreadsheet_import.present?
      end

      def new
        @procurement = current_user.rm3830_procurements.build(service_codes: params[:service_codes], region_codes: params[:region_codes])
        @back_path = back_path
        @back_text = 'Return to regions'
      end

      def edit
        redirect_to facilities_management_rm3830_procurement_path(@procurement) if params[:step].nil?
      end

      def create
        @procurement = current_user.rm3830_procurements.build(procurement_params)

        if @procurement.save(context: :contract_name)
          if @procurement.region_codes.empty?
            @procurement.start_detailed_search!
            redirect_to facilities_management_rm3830_procurement_path(@procurement)
          elsif params[:save_for_later].present?
            redirect_to facilities_management_rm3830_procurements_path
          else
            redirect_to facilities_management_rm3830_procurement_path(@procurement, what_happens_next: true)
          end
        else
          @errors = @procurement.errors
          @back_path = back_path
          render :new
        end
      end

      def update
        return if updates_for_show_pages
        return if updates_for_edit_pages

        update_procurement && return if params.key?(:facilities_management_rm3830_procurement)
      end

      def delete
        render layout: 'error'
      end

      def destroy
        DeleteProcurement.delete_procurement(@procurement)
        redirect_to facilities_management_rm3830_procurements_path(deleted: @procurement.contract_name)
      end

      def what_happens_next; end

      def quick_view_results_spreadsheet
        if @procurement.quick_search?
          spreadsheet_builder = SupplierShortlistSpreadsheetCreator.new(@procurement.id)
          spreadsheet_builder.build
          send_data spreadsheet_builder.to_xlsx, filename: "Quick view results (#{@procurement.contract_name}).xlsx", type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        else
          redirect_to facilities_management_rm3830_procurement_path(id: @procurement.id)
        end
      end

      def further_competition_spreadsheet
        if @procurement.further_competition?
          spreadsheet_builder = FurtherCompetitionDeliverablesMatrix.new(@procurement.id)
          spreadsheet_builder.build
          send_data spreadsheet_builder.to_xlsx, filename: 'further_competition_procurement_summary.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        else
          redirect_to facilities_management_rm3830_procurement_path(id: @procurement.id)
        end
      end

      def deliverables_matrix
        download_da_spreadsheet(DirectAwardDeliverablesMatrix, 'Attachment 2 - Statement of Requirements - Deliverables Matrix (DA).xlsx')
      end

      def price_matrix
        download_da_spreadsheet(PriceMatrixSpreadsheet, 'Attachment 3 - Price Matrix (DA).xlsx')
      end

      private

      def back_path
        helpers.journey_step_url_former(journey_step: 'locations', framework: 'RM3830', region_codes: @procurement.region_codes, service_codes: @procurement.service_codes) if @procurement.service_codes.present?
      end

      def redirect_from_delete_if_needed
        redirect_to facilities_management_rm3830_procurements_path unless @procurement.can_be_deleted?
      end

      def set_view_name
        @view_name = ProcurementRouter.new(@procurement.id,
                                           @procurement.aasm_state,
                                           step: params[:step],
                                           what_happens_next: params[:what_happens_next].present?,
                                           further_competition_chosen: params[:fc_chosen] == 'true').view
      end

      def update_procurement
        assign_procurement_parameters
        if @procurement.save(context: params[:facilities_management_rm3830_procurement][:step].try(:to_sym))
          @procurement.start_detailed_search! if @procurement.quick_search? && params['start_detailed_search'].present?
          @procurement.reload

          set_current_step

          redirect_to ProcurementRouter.new(@procurement.id, @procurement.aasm_state, step: @current_step).route
        else
          set_step_param
          set_view_name unless @procurement.quick_search?

          render :edit
        end
      end

      def redirect_if_missing_regions
        redirect_to facilities_management_rm3830_missing_regions_path(procurement_id: @procurement.id) if @procurement.procurement_buildings_missing_regions?
      end

      def assign_procurement_parameters
        @procurement.assign_attributes(procurement_params)

        # To need to do this is awful - it will trigger validations so that an invalid action can be recognised
        # that action - resulting in clearing the service_code collection in the store will not happen
        # we can however validate and push the custom message to the client from here
        # !WHY?! The browser is not sending the [:facilities_management_rm3830_procurement][:service_codes] value as empty
        #        if no checkboxes are checked
        #        Can the procurement_params specification not establish defaults?
        @procurement.service_codes = [] if params[:facilities_management_rm3830_procurement][:step].try(:to_sym) == :services && params[:facilities_management_rm3830_procurement][:service_codes].nil?
      end

      PARAMS_METHODS_SHOW = {
        bulk_upload_spreadsheet: :start_bulk_upload,
        change_the_contract_value: :change_the_contract_value,
        change_requirements: :continue_to_summary,
        continue_to_results: :continue_to_results,
        continue_from_change_contract_value: :continue_from_change_contract_value,
        continue_from_results: :continue_from_results,
        exit_bulk_upload: :exit_detailed_search_bulk_upload
      }.freeze

      def updates_for_show_pages
        update_step = (params.keys.map(&:to_sym) & PARAMS_METHODS_SHOW.keys).first

        if update_step
          send(PARAMS_METHODS_SHOW[update_step])
          true
        else
          false
        end
      end

      def updates_for_edit_pages
        update_step = params.dig('facilities_management_rm3830_procurement', 'step')&.to_sym

        case update_step
        when :services
          update_service_codes
        when :regions
          update_region_codes
        else
          return false
        end

        true
      end

      def start_bulk_upload
        @procurement.start_detailed_search_bulk_upload! if @procurement.may_start_detailed_search_bulk_upload?
        if params['bulk_upload_spreadsheet'] == t('facilities_management.rm3830.procurements.spreadsheet.save_and_return_link')
          redirect_to facilities_management_rm3830_procurements_path
        else
          redirect_to new_facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: @procurement.id)
        end
      end

      def download_da_spreadsheet(spreadsheet_creator, filename)
        spreadsheet_builder = spreadsheet_creator.new @procurement.first_unsent_contract.id
        spreadsheet_builder.build
        send_data spreadsheet_builder.to_xlsx, filename:
      end

      def change_the_contract_value
        @procurement.set_state_to_choose_contract_value!
        redirect_to facilities_management_rm3830_procurement_path(@procurement)
      end

      def continue_to_summary
        @procurement.set_state_to_detailed_search!
        redirect_to facilities_management_rm3830_procurement_path(@procurement)
      end

      def continue_to_results
        can_continue_to_results = case @procurement.aasm_state
                                  when 'detailed_search', 'choose_contract_value', 'results'
                                    procurement_valid?
                                  else
                                    true
                                  end

        if can_continue_to_results
          @procurement.set_state_to_results_if_possible! unless @procurement.results?
          redirect_to facilities_management_rm3830_procurement_path(@procurement)
        else
          redirect_to facilities_management_rm3830_procurement_path(@procurement, validate: true)
        end
      end

      def continue_from_change_contract_value
        @procurement.assign_attributes(procurement_params)
        if @procurement.valid?(:choose_contract_value)
          @procurement.set_state_to_results!
          redirect_to facilities_management_rm3830_procurement_path(@procurement)
        else
          set_view_name
          render :show
        end
      end

      def update_service_codes
        @procurement.assign_attributes(service_codes: procurement_params[:service_codes])
        if @procurement.save(context: :service_codes)
          redirect_to facilities_management_rm3830_procurement_path(id: @procurement.id)
        else
          params[:step] = 'services'
          render :edit
        end
      end

      def update_region_codes
        @procurement.assign_attributes(region_codes: procurement_params[:region_codes])
        if @procurement.save(context: :region_codes)
          redirect_to facilities_management_rm3830_procurement_path(id: @procurement.id)
        else
          params[:step] = 'regions'
          render :edit
        end
      end

      def exit_detailed_search_bulk_upload
        @procurement.set_state_to_detailed_search! if @procurement.detailed_search_bulk_upload?

        redirect_to facilities_management_rm3830_procurement_path(@procurement)
      end

      # sets the state of the procurement depending on the submission from the results view
      def continue_from_results
        @procurement.assign_attributes(procurement_route_params)

        if @procurement.valid?(:route_to_market)
          set_route_to_market
          redirect_to facilities_management_rm3830_procurement_path(@procurement, fc_chosen: @procurement.route_to_market == 'further_competition_chosen')
        else
          @view_name = 'results'
          initialize_page_description_from_view_name
          render :show
        end
      end

      def set_route_to_market
        case @procurement.route_to_market
        when 'da_draft'
          @procurement.start_direct_award!
        when 'further_competition'
          @procurement.start_further_competition!
        end
      end

      def redirect_to_contract_details_if_da_draft
        redirect_to facilities_management_rm3830_procurement_contract_details_path(procurement_id: @procurement.id) if @procurement.da_draft?
      end

      def redirect_if_unrecognised_step
        redirect_to facilities_management_rm3830_procurement_path(@procurement) unless RECOGNISED_STEPS.include? params[:step]
      end

      RECOGNISED_STEPS = %w[services regions].freeze

      def sent_offers
        current_user.rm3830_procurements.direct_award&.map(&:sent_offers)&.flatten&.sort_by { |each| [ProcurementSupplier::SENT_OFFER_ORDER.index(each.aasm_state), each.offer_sent_date] }
      end

      def live_contracts
        current_user.rm3830_procurements.direct_award.map(&:live_contracts)&.flatten&.sort_by(&:contract_signed_date)
      end

      def closed_contracts
        current_user.rm3830_procurements.where(aasm_state: ['direct_award', 'closed']).map(&:closed_contracts)&.flatten&.sort_by { |sent_offer| [sent_offer.contract_closed_date ? 1 : 0, sent_offer.contract_closed_date] }&.reverse
      end

      def procurement_route_params
        params.require(:facilities_management_rm3830_procurement).permit(:route_to_market)
      end

      def procurement_params
        params.require(:facilities_management_rm3830_procurement)
              .permit(
                :contract_name,
                :lot_number,
                :lot_number_selected_by_customer,
                service_codes: [],
                region_codes: [],
              )
      end

      def set_current_step
        @current_step = nil
        @current_step ||= params[:facilities_management_rm3830_procurement][:step] if params['next_step'].present?
      end

      def set_procurement
        @procurement = Procurement.find(params[:id] || params[:procurement_id])
      end

      def set_step_param
        params[:step] = params[:facilities_management_rm3830_procurement][:step] unless @procurement.quick_search?
      end

      def set_deleted_action_occurred
        @what_was_deleted = params[:deleted].to_s if params[:deleted].present?
      end

      def procurement_valid?
        @procurement.valid?(:continue)
      end

      protected

      def authorize_user
        @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
      end
    end
  end
end
