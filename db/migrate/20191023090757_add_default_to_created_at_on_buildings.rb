class AddDefaultToCreatedAtOnBuildings < ActiveRecord::Migration[5.2]
  def change
    change_column_default :facilities_management_buildings, :created_at, from: nil, to: 'now()' if column_exists? :facilities_management_buildings, :created_at
  end
end
