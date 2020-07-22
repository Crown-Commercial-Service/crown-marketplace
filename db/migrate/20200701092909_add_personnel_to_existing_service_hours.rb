class AddPersonnelToExistingServiceHours < ActiveRecord::Migration[5.2]
  def self.up
    FacilitiesManagement::ProcurementBuildingService.where(code: %w[H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6]).find_in_batches do |group|
      sleep(5)
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
