class AddIndexToFacilitiesManagementRegionalAvailabilitiesLotNumber < ActiveRecord::Migration[5.2]
  def change
    add_index :facilities_management_regional_availabilities, :lot_number,
              name: 'index_fm_regional_availabilities_on_lot_number'
  end
end
