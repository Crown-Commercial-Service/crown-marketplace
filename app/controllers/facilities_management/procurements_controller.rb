module FacilitiesManagement
  class ProcurementsController < FacilitiesManagement::FrameworkController
    include FacilitiesManagement::ProcurementsControllerLayoutHelper

    before_action :set_procurement, only: %i[show summary edit update delete destroy]
    before_action :authorize_user
    before_action :set_deleted_action_occurred, only: :index
    before_action :redirect_from_delete_if_needed, only: %i[delete destroy]
    before_action :redirect_to_contract_details_if_da_draft, only: :show
    before_action :ready_buildings, only: %i[show summary edit update]
    before_action :set_procurement_data, only: %i[show summary edit update]
    before_action :procurement_valid?, only: :show, if: -> { params[:validate].present? }
    before_action :set_current_step, only: %i[show edit]
    before_action :set_view_name, only: :show
    before_action :set_page_detail_from_view_name, only: :show, if: -> { page_definitions.key?(@view_name.to_sym) }
    before_action :set_summary_data, only: :summary

    def index
      @searches = current_user.procurements.where(aasm_state: FacilitiesManagement::Procurement::SEARCH).order(updated_at: :asc).sort_by { |search| FacilitiesManagement::Procurement::SEARCH_ORDER.index(search.aasm_state) }
      @in_draft = current_user.procurements.da_draft.order(updated_at: :asc)
      @sent_offers = sent_offers
      @contracts = live_contracts
      @closed_contracts = closed_contracts
      @further_competition_contracts = current_user.procurements.further_competition.order(updated_at: :asc)
    end

    def show
      redirect_to facilities_management_procurements_path if @procurement.da_journey_state == 'sent'
      redirect_to facilities_management_procurement_spreadsheet_import_path(procurement_id: @procurement, id: @procurement.spreadsheet_import) if @procurement.detailed_search_bulk_upload? && @procurement.spreadsheet_import.present?
    end

    def summary
      redirect_to edit_facilities_management_procurement_path(@procurement, step: @summary_page) if @procurement.send("#{@summary_page}_status") == :not_started
    end

    def new
      @procurement = current_user.procurements.build(service_codes: params[:service_codes], region_codes: params[:region_codes])
      @back_path = back_path
      @back_text = 'Return to regions'
    end

    def create
      @procurement = current_user.procurements.build(procurement_params)

      if @procurement.save(context: :contract_name)
        if @procurement.region_codes.empty?
          @procurement.start_detailed_search!
          redirect_to facilities_management_procurement_path(@procurement)
        elsif params[:save_for_later].present?
          redirect_to facilities_management_procurements_path
        else
          redirect_to facilities_management_procurement_path(@procurement, 'what_happens_next': true)
        end
      else
        @errors = @procurement.errors
        set_procurement_data
        @back_path = back_path
        render :new
      end
    end

    def edit
      redirect_to facilities_management_procurement_path(@procurement) if params[:step].nil?

      @back_link = FacilitiesManagement::ProcurementRouter.new(@procurement.id, @procurement.aasm_state).back_link
    end

    def update
      return if updates_for_show_pages
      return if updates_for_edit_pages

      update_procurement && return if params.key?(:facilities_management_procurement)
    end

    def delete; end

    def destroy
      FacilitiesManagement::DeleteProcurement.delete_procurement(@procurement)
      redirect_to facilities_management_procurements_path(deleted: @procurement.contract_name)
    end

    def what_happens_next; end

    def start_bulk_upload
      @procurement.start_detailed_search_bulk_upload! if @procurement.may_start_detailed_search_bulk_upload?
      if params['bulk_upload_spreadsheet'] == t('facilities_management.procurements.spreadsheet.save_and_return_link')
        redirect_to facilities_management_procurements_path
      else
        redirect_to new_facilities_management_procurement_spreadsheet_import_path(procurement_id: @procurement.id)
      end
    end

    def further_competition_spreadsheet
      init
      spreadsheet_builder = FacilitiesManagement::FurtherCompetitionSpreadsheetCreator.new(@procurement.id)
      spreadsheet_builder.build
      send_data spreadsheet_builder.to_xlsx, filename: 'further_competition_procurement_summary.xlsx', type: 'application/vnd.ms-excel'
    end

    def da_spreadsheets
      init
      if params[:spreadsheet] == 'prices_spreadsheet'
        spreadsheet1 = FacilitiesManagement::DirectAwardSpreadsheet.new @procurement.first_unsent_contract.id
        render xlsx: spreadsheet1.to_xlsx, filename: 'Attachment_3_-_Price_Matrix_(DA).xlsx'
      else
        spreadsheet_builder = FacilitiesManagement::DeliverableMatrixSpreadsheetCreator.new @procurement.first_unsent_contract.id
        spreadsheet2 = spreadsheet_builder.build
        render xlsx: spreadsheet2.to_stream.read, filename: 'Attachment_2_-_Statement_of_Requirements_-_Deliverables_Matrix_(DA).xlsx'
      end
    end

    private

    def init
      @procurement = current_user.procurements.find_by(id: params[:procurement_id])
    end

    def init_further_competition
      if params[:procurement_id]
        @procurement = current_user.procurements.where(id: params[:procurement_id]).first
        @start_date = @procurement.initial_call_off_start_date
      else
        @start_date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
      end
    end

    def back_path
      helpers.journey_step_url_former(journey_step: 'locations', region_codes: @procurement.region_codes, service_codes: @procurement.service_codes) if @procurement.service_codes.present?
    end

    def redirect_from_delete_if_needed
      redirect_to facilities_management_procurements_path unless @procurement.can_be_deleted?
    end

    def set_view_name
      @view_name = FacilitiesManagement::ProcurementRouter.new(@procurement.id,
                                                               @procurement.aasm_state,
                                                               step: params[:step],
                                                               what_happens_next: params[:what_happens_next].present?,
                                                               further_competition_chosen: params[:fc_chosen] == 'true').view
    end

    def update_procurement
      assign_procurement_parameters
      if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
        @procurement.start_detailed_search! if @procurement.quick_search? && params['start_detailed_search'].present?
        @procurement.reload

        set_current_step

        redirect_to FacilitiesManagement::ProcurementRouter.new(@procurement.id, @procurement.aasm_state, step: @current_step).route
      else
        set_step_param
        set_view_name unless @procurement.quick_search?

        render :edit
      end
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

    PARAMS_METHODS_SHOW = {
      'page': :paginate_procurement_buildings,
      'bulk_upload_spreadsheet': :start_bulk_upload,
      'change_the_contract_value': :change_the_contract_value,
      'change_requirements': :continue_to_summary,
      'continue_to_results': :continue_to_results,
      'continue_from_change_contract_value': :continue_from_change_contract_value,
      'continue_from_results': :continue_from_results,
      'exit_bulk_upload': :exit_detailed_search_bulk_upload
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
      update_step = params.dig('facilities_management_procurement', 'step')&.to_sym

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

    def change_the_contract_value
      @procurement.set_state_to_choose_contract_value!
      redirect_to facilities_management_procurement_path(@procurement)
    end

    def continue_to_summary
      @procurement.set_state_to_detailed_search!
      redirect_to facilities_management_procurement_path(@procurement)
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
        set_view_name
        render :show
      end
    end

    def update_service_codes
      @procurement.assign_attributes(service_codes: procurement_params[:service_codes])
      if @procurement.save(context: :service_codes)
        if @procurement.quick_search?
          redirect_to facilities_management_procurement_path(id: @procurement.id)
        else
          redirect_to facilities_management_procurement_summary_path(@procurement, summary: 'services')
        end
      else
        params[:step] = 'services'
        render :edit
      end
    end

    def update_region_codes
      @procurement.assign_attributes(region_codes: procurement_params[:region_codes])
      if @procurement.save(context: :region_codes)
        redirect_to facilities_management_procurement_path(id: @procurement.id)
      else
        params[:step] = 'regions'
        render :edit
      end
    end

    def exit_detailed_search_bulk_upload
      @procurement.set_state_to_detailed_search! if @procurement.detailed_search_bulk_upload?

      redirect_to facilities_management_procurement_path(@procurement)
    end

    def update_procurement_building_selection
      @procurement.assign_attributes(procurement_params)

      if @procurement.save(context: :buildings)
        redirect_to facilities_management_procurement_summary_path(@procurement, summary: 'buildings')
      else
        params[:step] = 'buildings'
        set_paginated_buildings_data

        render :edit
      end
    end

    def paginate_procurement_buildings
      update_procurement_building_selection && return if params.key?(:buildings)

      params[:page] = params.keys.select { |key| key.include?('paginate') }.first.split('-').last
      params[:step] = 'buildings'

      @procurement.assign_attributes(procurement_params)
      set_paginated_buildings_data

      render :edit
    end

    def set_paginated_buildings_data
      active_procurement_buildings = @procurement.procurement_buildings.select(&:active)

      @active_procurement_building_ids = active_procurement_buildings.map(&:id)

      @procurement.active_procurement_buildings.each do |procurement_building|
        active_procurement_buildings << procurement_building if @active_procurement_building_ids.exclude?(procurement_building.id)
      end

      @procurement_buildings = @procurement.procurement_buildings.order_by_building_name.page(params[:page])
      procurement_building_ids = @procurement_buildings.map(&:id)

      @hidden_procurement_buildings = active_procurement_buildings.reject { |procurement_building| procurement_building_ids.include? procurement_building.id }
    end

    # sets the state of the procurement depending on the submission from the results view
    def continue_from_results
      @procurement.assign_attributes(procurement_route_params)

      if @procurement.valid?(:route_to_market)
        set_route_to_market
        redirect_to facilities_management_procurement_path(@procurement, fc_chosen: @procurement.route_to_market == 'further_competition_chosen')
      else
        @view_name = 'results'
        set_page_detail_from_view_name
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
      redirect_to facilities_management_procurement_contract_details_path(procurement_id: @procurement.id) if @procurement.da_draft?
    end

    def sent_offers
      current_user.procurements.direct_award&.map(&:sent_offers)&.flatten&.sort_by { |each| [FacilitiesManagement::ProcurementSupplier::SENT_OFFER_ORDER.index(each.aasm_state), each.offer_sent_date] }
    end

    def live_contracts
      current_user.procurements.direct_award.map(&:live_contracts)&.flatten&.sort_by(&:contract_signed_date)
    end

    def closed_contracts
      current_user.procurements.where(aasm_state: ['direct_award', 'closed']).map(&:closed_contracts)&.flatten&.sort_by { |sent_offer| [sent_offer.contract_closed_date ? 1 : 0, sent_offer.contract_closed_date] }&.reverse
    end

    def procurement_route_params
      params.require(:facilities_management_procurement).permit(:route_to_market)
    end

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
              :lot_number,
              :lot_number_selected_by_customer,
              service_codes: [],
              region_codes: [],
              procurement_buildings_attributes: [:id,
                                                 :active,
                                                 service_codes: []]
            )
    end

    def set_current_step
      @current_step = nil
      @current_step ||= params[:facilities_management_procurement][:step] if params['next_step'].present?
    end

    def set_procurement
      @procurement = Procurement.find(params[:id] || params[:procurement_id])
    end

    def set_procurement_data
      @active_procurement_buildings = @procurement.procurement_buildings.try(:active).try(:order_by_building_name)
      set_buildings if params['step'] == 'buildings'
      set_active_procurement_buildings if %w[buildings buildings_and_services].include? params['summary']
    end

    def set_buildings
      @procurement.create_new_procurement_buildings if current_user.buildings.count != @procurement.procurement_buildings.count

      set_paginated_buildings_data
    end

    def set_summary_data
      @summary_page = params['summary']

      case @summary_page
      when 'buildings'
        set_active_procurement_buildings
      when 'service_requirements'
        set_procurement_buildings_requireing_service_info
      end
    end

    def set_active_procurement_buildings
      @active_procurement_buildings = @procurement.active_procurement_buildings.order_by_building_name.page(params[:page])
    end

    def set_procurement_buildings_requireing_service_info
      active_procurement_buildings = @procurement.active_procurement_buildings.order_by_building_name.select(&:requires_service_questions?)

      @active_procurement_buildings = Kaminari.paginate_array(active_procurement_buildings).page(params[:page])
    end

    def set_step_param
      params[:step] = params[:facilities_management_procurement][:step] unless @procurement.quick_search?
    end

    def ready_buildings
      @building_count = FacilitiesManagement::Building.where(user_id: current_user.id, status: 'Ready').size
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
