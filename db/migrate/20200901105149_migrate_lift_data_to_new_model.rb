class MigrateLiftDataToNewModel < ActiveRecord::Migration[5.2]
  def up
    rename_column :facilities_management_procurement_building_services, :lift_data, :lifts_data

    FacilitiesManagement::ProcurementBuildingService.where(code: 'C.5').find_in_batches do |group|
      sleep(5)
      group.each do |procurement_building_service|
        procurement_building_service.lifts_data.each do |lift|
          procurement_building_service.lifts.create(number_of_floors: lift)
        end
      end
    end

    remove_column :facilities_management_procurement_building_services, :lifts_data
  end

  def down
    add_column :facilities_management_procurement_building_services, :lifts_data, :string, array: true, default: []

    FacilitiesManagement::ProcurementBuildingService.where(code: 'C.5').find_in_batches do |group|
      sleep(5)
      group.each do |procurement_building_service|
        procurement_building_service.update(lifts_data: procurement_building_service.lift_data.map(&:to_s))
      end
    end

    rename_column :facilities_management_procurement_building_services, :lifts_data, :lift_data
  end
end
