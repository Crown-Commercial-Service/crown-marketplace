class AddLastUpdatedTofacilitiesManagementBuildings < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_buildings, :updated_at, :datetime unless column_exists? :facilities_management_buildings, :updated_at

    add_column :facilities_management_buildings, :status, :string, null: false, default: 'Incomplete' unless column_exists? :facilities_management_buildings, :status

    change_column_default :facilities_management_buildings, :updated_at, from: nil, to: 'now()' if column_exists? :facilities_management_buildings, :updated_at
  end
end
