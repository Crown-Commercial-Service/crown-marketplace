module FacilitiesManagement
  class ProcurementBuildingsController < FacilitiesManagement::FrameworkController
    before_action :set_procurement_building_data
    before_action :authorize_user
    before_action :set_step, only: %i[edit update]
    before_action :redirect_if_unrecognised_step, only: :edit
    before_action :set_volume_procurement_building_services, only: :show
    before_action :set_standards_procurement_building_services, only: :show

    def show; end

    def edit; end

    def update
      case @step
      when 'buildings_and_services'
        update_procurement_building
      when 'missing_region'
        update_missing_region
      end
    end

    private

    def update_missing_region
      @building.assign_attributes(building_params)
      @building.add_region_code_from_address_region

      if @building.save(context: :all)
        redirect_to facilities_management_procurement_path(@procurement)
      else
        render :edit
      end
    end

    def update_procurement_building
      @procurement_building.assign_attributes(procurement_building_params)

      if @procurement_building.save(context: @step.to_sym)
        redirect_to facilities_management_procurement_summary_path(@procurement, summary: @step)
      else
        render :edit
      end
    end

    def building_params
      params.require(:facilities_management_building)
            .permit(:address_region)
    end

    def procurement_building_params
      params.require(:facilities_management_procurement_building)
            .permit(service_codes: [])
    end

    def set_procurement_building_data
      @procurement_building = ProcurementBuilding.find(params[:id])
      @procurement = @procurement_building.procurement
      @building = @procurement_building.building
    end

    def set_step
      @step = params[:step]
    end

    def set_volume_procurement_building_services
      @volume_procurement_building_services = @procurement_building.sorted_procurement_building_services.map do |procurement_building_service|
        procurement_building_service.required_volume_contexts.map do |context|
          { procurement_building_service: procurement_building_service, context: context[1].first }
        end
      end.flatten
    end

    def set_standards_procurement_building_services
      @standards_procurement_building_services = @procurement_building.sorted_procurement_building_services.select(&:requires_service_standard?)
    end

    def redirect_if_unrecognised_step
      redirect_to facilities_management_procurement_path(@procurement) unless RECOGNISED_STEPS.include? params[:step]
    end

    RECOGNISED_STEPS = %w[buildings_and_services missing_region].freeze

    protected

    def authorize_user
      authorize! :manage, @procurement
    end
  end
end
