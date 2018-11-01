class CreateFacilitiesManagementRegionalAvailabilities < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_regional_availabilities, id: :uuid do |t|
      t.references :facilities_management_supplier,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_fm_regional_availabilities_on_fm_supplier_id' }
      t.text :lot_number, null: false
      t.text :region_code, null: false
      t.timestamps
    end
  end
end
