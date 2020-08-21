class FacilitiesManagement::ProcurementBuildingsServicesController < FacilitiesManagement::FrameworkController
  before_action :set_building_and_service_data
  before_action :authorize_user
  before_action :set_back_path
  before_action :set_partial
  before_action :set_lift_count

  def edit; end

  def update
    case params[:facilities_management_procurement_building_service][:service_question]
    when 'lifts'
      update_lifts
    when 'service_hours'
      update_procurement_building_service(service_hours_params, :service_hours)
    when 'volumes'
      update_procurement_building_service(volume_params, :volume)
    when 'service_standards'
      update_procurement_building_service(service_standards_params, :service_standard)
    else
      redirect_to facilities_management_procurement_building_path(@procurement_building)
    end
  end

  private

  def update_lifts
    @building_service.assign_attributes(lift_params)
    @building_service.lift_data&.reject!(&:blank?)
    if @building_service.save(context: :lifts)
      redirect_to facilities_management_procurement_building_path(@procurement_building)
    else
      set_lift_count
      render :edit
    end
  end

  def update_procurement_building_service(pbs_params, context)
    @building_service.assign_attributes(pbs_params)

    if @building_service.save(context: context)
      redirect_to facilities_management_procurement_building_path(@procurement_building)
    else
      params[:service_question] = params[:facilities_management_procurement_building_service][:service_question]
      set_partial
      render :edit
    end
  end

  def set_lift_count
    @lift_count = 1 if @building_service[:lift_data].blank?

    @lift_count = @building_service[:lift_data]&.length if @building_service[:lift_data]&.any?
  end

  def set_partial
    @partial_prefix = params[:service_question]
  end

  def lift_params
    params.require(:facilities_management_procurement_building_service)
          .permit(:lift_data, lift_data: [])
  end

  def service_hours_params
    params.require(:facilities_management_procurement_building_service)
          .permit(:service_hours,
                  :detail_of_requirement)
  end

  def volume_params
    params.require(:facilities_management_procurement_building_service)
          .permit(:no_of_appliances_for_testing,
                  :no_of_building_occupants,
                  :no_of_consoles_to_be_serviced,
                  :tones_to_be_collected_and_removed,
                  :no_of_units_to_be_serviced)
  end

  def service_standards_params
    params.require(:facilities_management_procurement_building_service)
          .permit(:service_standard)
  end

  def set_building_and_service_data
    @building_service = FacilitiesManagement::ProcurementBuildingService.find_by id: params[:id]
    @procurement_building = @building_service.procurement_building
    @building = @procurement_building.building
    @building_data = @building.building_json
  end

  def set_back_path
    @back_link = :back
  end

  protected

  def authorize_user
    authorize! :manage, @procurement_building.procurement
  end
end
