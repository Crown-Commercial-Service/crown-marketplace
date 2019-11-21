class AddServiceHoursToFacilitiesManagementProcurementBuildingServices < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'hstore'
    add_column :facilities_management_procurement_building_services, :service_hours, :hstore
    add_index :facilities_management_procurement_building_services, :service_hours, using: :gist, name: 'building_service_hours'
  end
end
