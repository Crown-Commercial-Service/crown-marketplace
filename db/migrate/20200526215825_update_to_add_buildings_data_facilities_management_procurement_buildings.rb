class UpdateToAddBuildingsDataFacilitiesManagementProcurementBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_buildings, :region, :text
    add_column :facilities_management_procurement_buildings, :building_type, :text
    add_column :facilities_management_procurement_buildings, :security_type, :text
    add_column :facilities_management_procurement_buildings, :address_town, :text
    add_column :facilities_management_procurement_buildings, :address_line_1, :text
    add_column :facilities_management_procurement_buildings, :address_line_2, :text
    add_column :facilities_management_procurement_buildings, :address_postcode, :text
    add_column :facilities_management_procurement_buildings, :address_region, :text
    add_column :facilities_management_procurement_buildings, :address_region_code, :text
    add_column :facilities_management_procurement_buildings, :building_name, :text
    add_column :facilities_management_procurement_buildings, :building_json, :jsonb
    add_column :facilities_management_procurement_buildings, :description, :text
  end
end
