class RemoveExternalAreaFromProcurementBuildingService < ActiveRecord::Migration[5.2]
  def up
    procurement_building_services_with_external_area = FacilitiesManagement::ProcurementBuildingService.where(code: 'G.5')

    procurement_building_services_with_external_area.each do |pbs|
      next unless pbs.procurement_building.external_area.nil?

      pbs.procurement_building.update(external_area: pbs.size_of_external_area)
    end

    remove_column :facilities_management_procurement_building_services, :size_of_external_area
  end

  def down
    add_column :facilities_management_procurement_building_services, :size_of_external_area, :bigint

    procurement_building_services_with_external_area = FacilitiesManagement::ProcurementBuildingService.where(code: 'G.5')

    procurement_building_services_with_external_area.each do |pbs|
      pbs.update(size_of_external_area: pbs.procurement_building.external_area)
    end
  end
end
