class RemoveUnusedBuildingAttributes < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities_management_procurement_buildings, :building_json, :jsonb
    remove_column :facilities_management_procurement_buildings, :region, :text
    remove_index :facilities_management_buildings, name: 'idx_buildings_service', column: "(building_json -> 'services'::text)", using: :gin
    remove_index :facilities_management_buildings, name: 'idx_buildings_gin', column: :building_json, using: :gin
    remove_index :facilities_management_buildings, name: 'idx_buildings_ginp', column: :building_json, opclass: :jsonb_path_ops, using: :gin
    remove_column :facilities_management_buildings, :building_json, :jsonb
    remove_column :facilities_management_buildings, :user_email, :text
    remove_column :facilities_management_buildings, :region, :text
  end
end
