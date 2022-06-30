class AddFrozenBuildingsForRM6232 < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities_management_rm6232_procurement_buildings, :frozen_building_data, :jsonb, default: {}
  end
end
