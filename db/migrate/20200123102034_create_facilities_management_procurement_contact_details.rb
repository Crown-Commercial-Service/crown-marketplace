class CreateFacilitiesManagementProcurementContactDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_procurement_contact_details, id: :uuid do |t|
      t.string :type, limit: 100
      t.string :name, limit: 50
      t.string :job_title, limit: 150
      t.text :email
      t.string :telephone_number, limit: 15
      t.text :organisation_address_line_1
      t.text :organisation_address_line_2
      t.text :organisation_address_town
      t.text :organisation_address_county
      t.text :organisation_address_postcode
      t.timestamps
      t.index ['id'], name: 'facilities_management_procurement_contact_detail_id_idx'
      t.index ['email'], name: 'facilities_management_procurement_contact_detail_email_idx'
    end
  end
end
