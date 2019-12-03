class AddServiceHoursToFacilitiesManagementProcurementBuildingServices < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_building_services, :service_hours, :jsonb
  end
end
