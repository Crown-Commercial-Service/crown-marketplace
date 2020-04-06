class Updatecolumnsinfacilitiesmanagementbuildings < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities_management_buildings, :building_ref, :text
    change_column_default :facilities_management_buildings, :id, from: nil, to: "gen_random_uuid()"
    change_column :facilities_management_buildings, :updated_by, :text, :null => true
  end
end
