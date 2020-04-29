class ChangeVolumeFromIntegerToBigInt < ActiveRecord::Migration[5.2]
  def up
    change_column :facilities_management_procurement_building_services, :no_of_appliances_for_testing, :bigint
    change_column :facilities_management_procurement_building_services, :no_of_building_occupants, :bigint
    change_column :facilities_management_procurement_building_services, :size_of_external_area, :bigint
    change_column :facilities_management_procurement_building_services, :no_of_consoles_to_be_serviced, :bigint
    change_column :facilities_management_procurement_building_services, :tones_to_be_collected_and_removed, :bigint
    change_column :facilities_management_procurement_building_services, :no_of_units_to_be_serviced, :bigint
  end

  def down
    change_column :facilities_management_procurement_building_services, :no_of_appliances_for_testing, :integer
    change_column :facilities_management_procurement_building_services, :no_of_building_occupants, :integer
    change_column :facilities_management_procurement_building_services, :size_of_external_area, :integer
    change_column :facilities_management_procurement_building_services, :no_of_consoles_to_be_serviced, :integer
    change_column :facilities_management_procurement_building_services, :tones_to_be_collected_and_removed, :integer
    change_column :facilities_management_procurement_building_services, :no_of_units_to_be_serviced, :integer
  end
end
