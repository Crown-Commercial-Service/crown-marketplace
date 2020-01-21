require 'facilities_management/fm_buildings_data'
module FacilitiesManagement
  module Beta
    class ProcurementsController < FrameworkController
      before_action :set_procurement, only: %i[show edit update destroy results]
      before_action :set_deleted_action_occurred, only: %i[index]
      before_action :set_edit_state, only: %i[index show edit update destroy]
      before_action :user_buildings_count, only: %i[show edit update]
      before_action :set_procurement_data, only: %i[show edit update results]
      before_action :set_new_procurement_data, only: %i[new]
      before_action :procurement_valid?, only: :show, if: -> { params[:validate].present? }
      before_action :build_page_details, only: %i[show edit update destroy results]

      def index
        @procurements = current_user.procurements
        @searches = current_user.procurements.where(aasm_state: FacilitiesManagement::Procurement::SEARCH)
        @sent_offers = current_user.procurements.where(aasm_state: FacilitiesManagement::Procurement::SENT_OFFER)
        @in_draft = current_user.procurements.DA_draft
        @contracts = current_user.procurements.where(aasm_state: :accepted_and_signed)
        @closed_contract = current_user.procurements.where(aasm_state: :closed)
      end

      def show
        redirect_to edit_facilities_management_beta_procurement_url(id: @procurement.id, delete: @delete) if @procurement.quick_search? && @delete
        redirect_to edit_facilities_management_beta_procurement_url(id: @procurement.id) if @procurement.quick_search? && !@delete

        @view_name = set_view_data unless @procurement.quick_search?
      end

      def new
        @procurement = current_user.procurements.build(service_codes: params[:service_codes], region_codes: params[:region_codes])
      end

      def create
        @procurement = current_user.procurements.build(procurement_params)

        if @procurement.save(context: :name)
          redirect_to edit_facilities_management_beta_procurement_url(id: @procurement.id)
        else
          @errors = @procurement.errors
          set_procurement_data
          render :new
        end
      end

      def edit
        if @procurement.quick_search?
          render :edit
        else
          @back_link = FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, procurement_state: @procurement.aasm_state, step: params[:step]).back_link

          redirect_to facilities_management_beta_procurement_url(id: @procurement.id) unless FacilitiesManagement::ProcurementRouter::STEPS.include?(params[:step])
        end
      end

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      def update
        continue_to_summary && return if params['change_requirements'].present?

        continue_to_results && return if params['continue_to_results'].present?

        set_route_to_market && return if params['set_route_to_market'].present?

        update_procurement if params['facilities_management_procurement'].present?
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

      # DELETE /procurements/1
      # DELETE /procurements/1.json
      def destroy
        @procurement.destroy

        respond_to do |format|
          format.html { redirect_to facilities_management_beta_procurements_url(deleted: @procurement.name) }
          format.json { head :no_content }
        end
      end

      def summary
        @page_data = {}
        @page_data[:model_object] = @procurement
      end

      def results
        redirect_to(facilities_management_beta_procurement_path(@procurement)) && return unless verify_status('results')

        set_results_page_data
        @procurement[:route_to_market] = @procurement.aasm_state
      end

      private

      def set_view_data
        view_name = FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, procurement_state: @procurement.aasm_state, step: @current_step).view
        build_page_details(view_name.to_sym)

        case view_name
        when 'results'
          set_results_page_data
          @procurement[:route_to_market] = @procurement.aasm_state
        else
          @page_data = {}
          @page_data[:model_object] = @procurement
        end

        view_name
      end

      def update_procurement
        assign_procurement_parameters
        if @procurement.save(context: params[:facilities_management_procurement][:step].try(:to_sym))
          @procurement.start_detailed_search! if @procurement.quick_search? && params['start_detailed_search'].present?
          @procurement.reload

          set_current_step

          redirect_to FacilitiesManagement::ProcurementRouter.new(id: @procurement.id, procurement_state: @procurement.aasm_state, step: @current_step).route
        else
          set_step_param
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

      def verify_status(status)
        if status == 'results'
          return false if %w[quick_search detailed_search].include?(@procurement.aasm_state.downcase)

          return true
        end

        @procurement.aasm_state.to_sym == status.to_sym
      end

      def continue_to_summary
        @procurement.set_state_to_detailed_search
        @procurement.save
        redirect_to facilities_management_beta_procurement_path(@procurement)
      end

      def continue_to_results
        if procurement_valid?
          @procurement.save_eligible_suppliers
          @procurement[:eligible_for_da] = eligible_for_direct_award?
          @procurement.set_state_to_results
          @procurement.save
          redirect_to facilities_management_beta_procurement_path(@procurement)
        else
          redirect_to facilities_management_beta_procurement_path(@procurement, validate: true)
        end
      end

      # sets the state of the procurement depending on the submission from the results view
      def set_route_to_market
        if params[:commit] == page_details(:results)[:secondary_text]
          @procurement.set_state_to_detailed_search
          @procurement.save

          redirect_to facilities_management_beta_procurement_path(@procurement)
          return
        end

        @procurement.assign_attributes(procurement_route_params)

        unless @procurement.valid?(:route_to_market)
          build_page_details(:results)
          set_results_page_data
          render 'results'
          return true
        end

        @procurement.start_direct_award if @procurement[:route_to_market] == 'DA_draft'
        @procurement.start_further_competition if @procurement[:route_to_market] == 'further_competition'
        @procurement.save

        redirect_to facilities_management_beta_procurement_path(@procurement)
      end

      def eligible_for_direct_award?
        DirectAward.new(@procurement.buildings_standard, @procurement.services_standard, @procurement.priced_at_framework, @procurement.assessed_value).calculate
      end

      helper_method :eligible_for_direct_award?

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

      def procurement_route_params
        params.require(:facilities_management_procurement).permit(:route_to_market)
      end

      def procurement_params
        params.require(:facilities_management_procurement)
              .permit(
                :name,
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
                :mobilisation_period_required,
                :extensions_required,
                :security_policy_document_required,
                :security_policy_document_name,
                :security_policy_document_version_number,
                :security_policy_document_date_dd,
                :security_policy_document_date_mm,
                :security_policy_document_date_yyyy,
                :security_policy_document_file,
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
                                                   service_codes: []]
              )
      end

      def set_current_step
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
        @buildings_data = FMBuildingData.new.get_building_data(current_user.email.to_s)
        @buildings_data.each do |building|
          building_data = JSON.parse(building['building_json'].to_s)
          @procurement.find_or_build_procurement_building(building_data, building_data['id']) if building['status'] == 'Ready'
        end
      end

      def find_regions(region_codes)
        @regions = Nuts2Region.where(code: region_codes)
      end

      def find_services(service_codes)
        @services = Service.where(code: service_codes)
      end

      def set_step_param
        params[:step] = params[:facilities_management_procurement][:step] if @procurement.detailed_search?
      end

      def user_buildings_count
        @building_count = FMBuildingData.new.get_count_of_buildings(current_user.email.to_s)
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
                                          page_details(action)[:sub_title]),
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
      # rubocop:enable Style/MultilineIfModifier
      # rubocop:enable Metrics/AbcSize

      def page_details(action)
        @page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
      end

      def page_definitions
        @page_definitions ||= {
          default: {
            caption1: @procurement[:name],
            continuation_text: 'Continue',
            return_url: facilities_management_beta_procurements_path,
            return_text: 'Return to procurements dashboard',
            secondary_name: 'change_requirements',
            secondary_text: 'Change requirements',
            secondary_url: facilities_management_beta_procurements_path,
            back_text: 'Back',
            back_url: facilities_management_beta_procurements_path
          },
          results: {
            page_title: 'Results',
            primary_name: 'set_route_to_market'
          },
          direct_award_pricing: {
            caption1: @procurement[:name],
            page_title: 'Direct Award Pricing',
            back_url: facilities_management_beta_procurement_results_path(@procurement)
          },
          further_competition: {
            caption1: @procurement[:name],
            page_title: 'Further competition',
            back_url: facilities_management_beta_procurement_results_path(@procurement)
          },
          summary: {
            page_title: 'Summary',
            return_url: facilities_management_beta_procurements_path,
          }
        }.freeze
      end
    end
  end
end
