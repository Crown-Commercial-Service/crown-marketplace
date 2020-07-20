class AddExternalAreaToExistingBuildings < ActiveRecord::Migration[5.2]
  def change
    # rubocop:disable Rails/SkipsModelValidations
    nil_external_area_buildings = FacilitiesManagement::Building.where(external_area: nil)
    nil_external_area_buildings.update_all(external_area: 0)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
