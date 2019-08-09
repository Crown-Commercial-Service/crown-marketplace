class CreateLegalServicesSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :legal_services_suppliers, id: :uuid do |t|
      t.text :name, null: false
      t.text :email
      t.text :phone_number
      t.text :website
      t.text :address
      t.boolean :sme
      t.integer :duns
      t.text :lot_1_prospectus_link
      t.text :lot_2_prospectus_link
      t.text :lot_3_prospectus_link
      t.text :lot_4_prospectus_link
      t.timestamps
    end
  end
end
