class AddLiftdataToBuildingServices < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_building_services, :lift_data, :string, array: true, default: []
  end
end
