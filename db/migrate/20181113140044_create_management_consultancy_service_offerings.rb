class CreateManagementConsultancyServiceOfferings < ActiveRecord::Migration[5.2]
  def change
    create_table :management_consultancy_service_offerings, id: :uuid do |t|
      t.references :management_consultancy_supplier,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_mc_service_offerings_on_mc_supplier_id' }
      t.text :lot_number, null: false
      t.text :service_code, null: false
      t.timestamps
    end
  end
end
