class AddPersonnelToExistingServiceHours < ActiveRecord::Migration[5.2]
  def self.up
    FacilitiesManagement::ProcurementBuildingService.find_in_batches do |group|
      sleep(50)
      group.each do |procurement_building_service|
        if procurement_building_service.service_hours.friday.service_choice.present? && procurement_building_service.service_hours.personnel.nil?
          procurement_building_service.service_hours.personnel = 1
          procurement_building_service.save
        end
      end
    end
  end

  def self.down; end
end
