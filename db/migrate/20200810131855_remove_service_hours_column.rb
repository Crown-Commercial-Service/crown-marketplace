class RemoveServiceHoursColumn < ActiveRecord::Migration[5.2]
  def up
    remove_column :facilities_management_procurement_building_services, :service_hours
    rename_column :facilities_management_procurement_building_services, :total_service_hours, :service_hours
  end

  def down
    rename_column :facilities_management_procurement_building_services, :service_hours, :total_service_hours
    add_column :facilities_management_procurement_building_services, :service_hours, :jsonb
  end
end
