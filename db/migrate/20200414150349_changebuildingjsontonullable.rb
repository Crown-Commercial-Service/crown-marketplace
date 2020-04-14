class Changebuildingjsontonullable < ActiveRecord::Migration[5.2]
  def change
    change_column :facilities_management_buildings, :building_json, :jsonb, null: true
  end
end
