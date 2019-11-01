class AddAddressLine1AddressLine2TownCountyPostcodeAndActiveToProcurementBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_buildings, :address_line_1, :string, limit: 255
    add_column :facilities_management_procurement_buildings, :address_line_2, :string, limit: 255
    add_column :facilities_management_procurement_buildings, :town, :string, limit: 255
    add_column :facilities_management_procurement_buildings, :county, :string, limit: 255
    add_column :facilities_management_procurement_buildings, :postcode, :string, limit: 20
    add_column :facilities_management_procurement_buildings, :active, :boolean
  end
end
