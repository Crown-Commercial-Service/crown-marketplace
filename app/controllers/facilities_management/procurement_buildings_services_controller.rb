class FacilitiesManagement::ProcurementBuildingsServicesController < FacilitiesManagement::FrameworkController
  before_action :set_building_and_service_data
  before_action :authorize_user
  before_action :set_back_path
  before_action :set_partial
  before_action :set_lift_count

  def show
    render :edit
  end

  def update
    if params[:facilities_management_procurement_building_service][:step] == 'lifts'
      update_lifts
    elsif params[:facilities_management_procurement_building_service][:step] == 'service_hours'
      update_service_hours
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

  def update_service_hours
    @building_service.assign_attributes(service_hours_params)

    if @building_service.save(context: :service_hours)
      redirect_to facilities_management_procurement_building_path(@procurement_building)
    else
      render :edit
    end
  end

  def set_lift_count
    @lift_count = 1 if @building_service[:lift_data].blank?

    @lift_count = @building_service[:lift_data]&.length if @building_service[:lift_data]&.any?
  end

  def set_partial
    @partial_prefix = ''
    return @partial_prefix = 'lifts' if @building_service.code == 'C.5'

    @partial_prefix = 'service_hours'
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
