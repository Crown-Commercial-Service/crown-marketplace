class AddLastUpdatedTofacilitiesManagementBuildings < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :facilities_management_buildings, :updated_at
      add_column :facilities_management_buildings, :updated_at, :datetime
    end

    unless column_exists? :facilities_management_buildings, :status
      add_column :facilities_management_buildings, :status, :string, null: false, default: 'Incomplete'
    end

    change_column_default :facilities_management_buildings, :updated_at, from: nil, to: 'now()'
  end
end
