class AddIndexToFacilitiesManagementServiceOfferingsLotNumber < ActiveRecord::Migration[5.2]
  def change
    add_index :facilities_management_service_offerings, :lot_number,
              name: 'index_fm_service_offerings_on_lot_number'
  end
end
