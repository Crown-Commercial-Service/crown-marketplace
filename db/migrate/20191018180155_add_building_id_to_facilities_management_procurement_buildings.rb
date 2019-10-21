class AddBuildingIdToFacilitiesManagementProcurementBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_buildings, :building_id, :uuid
  end
end
