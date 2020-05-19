class RemoveNameFromProcurementBuildings < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities_management_procurement_buildings, :name, :string, limit: 255
  end
end
