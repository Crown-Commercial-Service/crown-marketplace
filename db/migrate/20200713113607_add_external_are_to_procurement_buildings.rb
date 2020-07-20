class AddExternalAreToProcurementBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_buildings, :external_area, :integer
  end
end
