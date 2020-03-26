class AddServiceStandardsToProcurementBuildingServices < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_building_services, :service_standard, :string, limit: 1
  end
end
