class Updatecolumnsinfacilitiesmanagementbuildings < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        remove_column :facilities_management_buildings, :building_ref, :text
        remove_column :facilities_management_buildings, :address_county, :text
        change_column_default :facilities_management_buildings, :id, from: nil, to: 'gen_random_uuid()'
        change_column :facilities_management_buildings, :updated_by, :text, null: true
      end
      dir.down do
        add_column :facilities_management_buildings, :building_ref, :text
        add_column :facilities_management_buildings, :address_county, :text
        change_column_default :facilities_management_buildings, :id, from: 'gen_random_uuid()', to: nil
        change_column :facilities_management_buildings, :updated_by, :text, null: true
      end
    end
  end
end
