module FacilitiesManagement
  class ProcurementBuildingsController < FacilitiesManagement::FrameworkController
    before_action :set_procurement_building
    before_action :authorize_user
    before_action :set_building_data
    before_action :set_back_path
    before_action :set_service_question, only: %i[edit update]

    def show; end

    def edit; end

    def update
      @procurement_building.assign_attributes(procurement_building_params)

      # save(context: context) does not work for nested objects (fix might be coming at some point: https://github.com/rails/rails/pull/24135)
      # if procurement_building_services are valid
      if !@procurement_building.procurement_building_services.map { |pbs| pbs.valid?(@service_question.to_sym) }.include?(false)
        @procurement_building.save
        redirect_to facilities_management_procurement_building_path(@procurement_building)
      else
        render :edit
      end
    end

    private

    def procurement_building_params
      params.require(:facilities_management_procurement_building)
            .permit(
              procurement_building_services_attributes: %i[id
                                                           no_of_appliances_for_testing
                                                           no_of_building_occupants
                                                           no_of_units_to_be_serviced
                                                           size_of_external_area
                                                           no_of_consoles_to_be_serviced
                                                           tones_to_be_collected_and_removed
                                                           service_standard
                                                           service_hours
                                                           detail_of_requirement]
            )
    end

    def set_procurement_building
      @procurement_building = ProcurementBuilding.find(params[:id])
    end

    def set_building_data
      @building = @procurement_building.building
    end

    def set_back_path
      @back_link = :back
    end

    def set_service_question
      @service_question = params[:service_question]
    end

    protected

    def authorize_user
      authorize! :manage, @procurement_building.procurement
    end
  end
end
