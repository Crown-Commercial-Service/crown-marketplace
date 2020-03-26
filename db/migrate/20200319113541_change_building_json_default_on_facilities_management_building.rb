class ChangeBuildingJsonDefaultOnFacilitiesManagementBuilding < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        change_column_default :facilities_management_buildings, :building_json, '{}'
        change_column :facilities_management_buildings, :created_at, :timestamp, default: -> { 'CURRENT_TIMESTAMP' }
        change_column :facilities_management_buildings, :updated_at, :timestamp, default: -> { 'CURRENT_TIMESTAMP' }
      end

      dir.down do
        change_column_default :facilities_management_buildings, :building_json, nil
        change_column_default :facilities_management_buildings, :created_at, nil
        change_column_default :facilities_management_buildings, :updated_at, nil
      end
    end
  end
end
