class CreateLegalServicesServiceOfferings < ActiveRecord::Migration[5.2]
  def change
    create_table :legal_services_service_offerings, id: :uuid do |t|
      t.references :legal_services_supplier,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_ls_service_offerings_on_ls_supplier_id' }
      t.text :lot_number, null: false
      t.text :service_code, null: false
      t.timestamps
    end
  end
end
