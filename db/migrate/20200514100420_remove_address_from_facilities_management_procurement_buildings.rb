class RemoveAddressFromFacilitiesManagementProcurementBuildings < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities_management_procurement_buildings, :address_line_1, :string, limit: 255
    remove_column :facilities_management_procurement_buildings, :address_line_2, :string, limit: 255
    remove_column :facilities_management_procurement_buildings, :town, :string, limit: 255
    remove_column :facilities_management_procurement_buildings, :county, :string, limit: 255
    remove_column :facilities_management_procurement_buildings, :postcode, :string, limit: 255
  end
end
