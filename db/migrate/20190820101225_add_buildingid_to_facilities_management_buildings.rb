class AddBuildingidToFacilitiesManagementBuildings < ActiveRecord::Migration[5.2]
  # rubocop:disable Rails/DangerousColumnNames
  def change
    add_column :facilities_management_buildings, :id, :uuid
    add_index :facilities_management_buildings, :id, unique: true
  end
  # rubocop:enable Rails/DangerousColumnNames
end
