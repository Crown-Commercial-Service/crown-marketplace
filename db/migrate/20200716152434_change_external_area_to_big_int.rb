class ChangeExternalAreaToBigInt < ActiveRecord::Migration[5.2]
  def up
    change_column :facilities_management_buildings, :external_area, :bigint
    change_column :facilities_management_procurement_buildings, :external_area, :bigint
  end

  def down
    change_column :facilities_management_buildings, :external_area, :integer
    change_column :facilities_management_procurement_buildings, :external_area, :integer
  end
end
