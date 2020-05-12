class FacilitiesManagement::ProcurementBuildingsServicesController < ApplicationController
  before_action :set_building_and_service_data
  before_action :set_back_path
  before_action :set_partial
  before_action :set_lift_count

  def show
    render :edit
  end

  def edit
    raise ActionController::RoutingError, 'not found' if @building_service.blank?
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
    @building_service.assign_attributes(service_hours_params.select { |attribute| attribute unless attribute.empty? }.to_h)

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
          .permit(service_hours: [{
                    monday: FacilitiesManagement::ServiceHourChoice::PARAMETERS,
                    tuesday: FacilitiesManagement::ServiceHourChoice::PARAMETERS,
                    wednesday: FacilitiesManagement::ServiceHourChoice::PARAMETERS,
                    thursday: FacilitiesManagement::ServiceHourChoice::PARAMETERS,
                    friday: FacilitiesManagement::ServiceHourChoice::PARAMETERS,
                    saturday: FacilitiesManagement::ServiceHourChoice::PARAMETERS,
                    sunday: FacilitiesManagement::ServiceHourChoice::PARAMETERS
                  }])
  end

  def set_building_and_service_data
    bs_from_db = FacilitiesManagement::ProcurementBuildingService.find_by id: params[:id]
    @procurement_building = procurement_building_from_bs(bs_from_db) if bs_from_db.present?

    @building = building_from_pb(@procurement_building) if @procurement_building.present?

    @building_data = @building.building_json if @building.present?

    @building_service = bs_from_db if @building.present?
  end

  def procurement_building_from_bs(bs_from_db)
    current_user.procurements.map(&:procurement_buildings).flatten.select do |pb|
      pb[:id] == bs_from_db[:facilities_management_procurement_building_id]
    end&.first
  end

  def building_from_pb(proc_building)
    building_id = proc_building.building_id if proc_building.present?
    FacilitiesManagement::Building.find(building_id) if proc_building.present?
  end

  def set_back_path
    @back_link = :back
  end
end
