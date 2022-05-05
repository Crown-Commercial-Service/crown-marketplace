class CreateSuppliersDataTable < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_suppliers, id: :uuid do |t|
      t.string :supplier_name, limit: 255
      t.string :contact_name, limit: 255
      t.string :contact_email, limit: 255
      t.string :contact_phone, limit: 255
      t.boolean :sme
      t.string :duns, limit: 255
      t.string :registration_number, limit: 255
      t.string :address_line_1, limit: 255
      t.string :address_line_2, limit: 255
      t.string :address_town, limit: 255
      t.string :address_county, limit: 255
      t.string :address_postcode, limit: 255
      t.boolean :active, default: true

      t.timestamps

      t.index :supplier_name, unique: true
      t.index :active
    end
  end
end
