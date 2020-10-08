class AddIndexToBuildingsName < ActiveRecord::Migration[5.2]
  def change
    add_index :facilities_management_buildings, 'lower(building_name)', using: :btree, name: 'index_fm_buildings_on_lower_building_name'
  end
end
