class Defaultforfmbuildingscreatedat < ActiveRecord::Migration[5.2]
  def change
    if column_exists?(:facilities_management_buildings, :created_at)
      change_column_null :facilities_management_buildings, :created_at, true
      change_column_default :facilities_management_buildings, :created_at, from: '', to: 'now()'
    else
      add_column :facilities_management_buildings, :created_at, :datetime, from: '', to: 'now()', null: true
    end
    if column_exists?(:facilities_management_buildings, :updated_at)
      change_column_null :facilities_management_buildings, :updated_at, true
      change_column_default :facilities_management_buildings, :updated_at, from: '', to: 'now()'
    else
      add_column :facilities_management_buildings, :updated_at, :datetime, from: '', to: 'now()', null: true
    end
  end
end
