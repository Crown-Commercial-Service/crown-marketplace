class AddOtherBuildingTypeAndOtherSecurityTypeToProcurementBuildings < ActiveRecord::Migration[5.2]
  def up
    add_column :facilities_management_procurement_buildings, :other_building_type, :string
    add_column :facilities_management_procurement_buildings, :other_security_type, :string

    # rubocop:disable Rails/SkipsModelValidations
    FacilitiesManagement::ProcurementBuilding.all.each { |pb| pb.update_columns(other_security_type: pb.building.other_security_type, other_building_type: pb.building.other_building_type) }
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    remove_column :facilities_management_procurement_buildings, :other_building_type, :string
    remove_column :facilities_management_procurement_buildings, :other_security_type, :string
  end
end
