class Changebuildingjsontonullable < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        change_column :facilities_management_buildings, :building_json, :jsonb, null: true
      end

      dir.down do
        change_column :facilities_management_buildings, :building_json, :jsonb, null: true
      end
    end
  end
end
