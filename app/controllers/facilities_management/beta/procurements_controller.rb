require 'facilities_management/fm_buildings_data'
module FacilitiesManagement
  module Beta
    class ProcurementsController < FrameworkController
      before_action :set_procurement, only: %i[show edit update destroy]
      before_action :set_deleted_action_occurred, only: %i[index]
      before_action :set_edit_state, only: %i[index show edit update destroy]
      before_action :user_buildings_count, only: %i[show edit update]
      before_action :set_procurement_data, only: %i[show edit update]
      before_action :set_new_procurement_data, only: %i[new]

      def index
        @procurements = current_user.procurements
      end

      def show
        redirect_to edit_facilities_management_beta_procurement_url(id: @procurement.id, delete: @delete) if @procurement.quick_search? && @delete
        redirect_to edit_facilities_management_beta_procurement_url(id: @procurement.id) if @procurement.quick_search? && !@delete
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

      # rubocop:disable Metrics/AbcSize
      def update
        @procurement.assign_attributes(procurement_params)

        # To need to do this is awful - it will trigger validations so that an invalid action can be recognised
        # that action - resulting in clearing the service_code collection in the store will not happen
        # we can however validate and push the custom message to the client from here
        # !WHY?! The browser is not sending the [:facilities_management_procurement][:service_codes] value as empty
        #        if no checkboxes are checked
        #        Can the procurement_params specification not establish defaults?
        @procurement.service_codes = [] if params[:facilities_management_procurement][:step].try(:to_sym) == :services &&
                                           params[:facilities_management_procurement][:service_codes].nil?

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
      # rubocop:enable Metrics/AbcSize

      # DELETE /procurements/1
      # DELETE /procurements/1.json
      def destroy
        @procurement.destroy

        respond_to do |format|
          format.html { redirect_to facilities_management_beta_procurements_url(deleted: @procurement.name) }
          format.json { head :no_content }
        end
      end

      private

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
        @procurement = Procurement.find(params[:id])
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
    end
  end
end
