class AddNewColumnsToProcurementBuildingServices < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_building_services, :total_service_hours, :bigint
    add_column :facilities_management_procurement_building_services, :detail_of_requirement, :text
  end
end
