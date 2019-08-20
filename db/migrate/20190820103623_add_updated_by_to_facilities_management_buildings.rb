class AddUpdatedByToFacilitiesManagementBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_buildings, :updated_by, :string
  end
end
