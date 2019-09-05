class SetNotnullsOnBuildingColumns < ActiveRecord::Migration[5.2]
  def change
    change_column_null :facilities_management_buildings, :id, false
    change_column_null :facilities_management_buildings, :updated_by, false
    change_column_null :facilities_management_buildings, :updated_at, false
  end
end
