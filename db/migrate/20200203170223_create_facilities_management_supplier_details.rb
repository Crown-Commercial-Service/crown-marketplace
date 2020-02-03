class CreateFacilitiesManagementSupplierDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_supplier_details, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.string :name, limit: 255
      t.boolean :lot1a
      t.boolean :lot1b
      t.boolean :lot1c
      t.boolean :direct_award
      t.boolean :sme
      t.string :contact_name, limit: 255
      t.string :contact_email, limit: 255
      t.string :contact_number, limit: 255
      t.string :duns, limit: 255
      t.string :registration_number, limit: 255
      t.string :address_line_1, limit: 255
      t.string :address_line_2, limit: 255
      t.string :address_town, limit: 255
      t.string :address_county, limit: 255
      t.string :address_postcode, limit: 255

      t.timestamps
    end
  end
end
