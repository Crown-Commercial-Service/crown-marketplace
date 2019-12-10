class AddVolumeQuestionsToFacilitiesManagementProcurementBuildingServices < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_building_services, :no_of_appliances_for_testing, :integer
    add_column :facilities_management_procurement_building_services, :no_of_building_occupants, :integer
    add_column :facilities_management_procurement_building_services, :size_of_external_area, :integer
    add_column :facilities_management_procurement_building_services, :no_of_consoles_to_be_serviced, :integer
    add_column :facilities_management_procurement_building_services, :tones_to_be_collected_and_removed, :integer
    add_column :facilities_management_procurement_building_services, :no_of_units_to_be_serviced, :integer
  end
end
