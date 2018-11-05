class CreateFacilitiesManagementServiceOfferings < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_service_offerings, id: :uuid do |t|
      t.references :facilities_management_supplier,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_fm_service_offerings_on_fm_supplier_id' }
      t.text :lot_number, null: false
      t.text :service_code, null: false
      t.timestamps
    end
  end
end
