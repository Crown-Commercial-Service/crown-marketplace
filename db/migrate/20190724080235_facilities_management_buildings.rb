class FacilitiesManagementBuildings < ActiveRecord::Migration[5.2]
  def change
    create_table 'facilities_management_buildings', id: false do |t|
      t.text 'user_id', null: false
      t.jsonb 'building_json', null: false
      t.timestamps
      t.index "((building_json -> 'services'::text))", name: 'idx_buildings_service', using: :gin
      t.index ['building_json'], name: 'idx_buildings_gin', using: :gin
      t.index ['building_json'], name: 'idx_buildings_ginp', opclass: :jsonb_path_ops, using: :gin
      t.index ['user_id'], name: 'idx_buildings_user_id'
    end
  end
end
