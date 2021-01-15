class RemoveFacilitiesManagementSupplierDetails < ActiveRecord::Migration[5.2]
  def change
    drop_table 'facilities_management_supplier_details', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
      t.uuid 'user_id'
      t.string 'name', limit: 255
      t.boolean 'lot1a'
      t.boolean 'lot1b'
      t.boolean 'lot1c'
      t.boolean 'direct_award'
      t.boolean 'sme'
      t.string 'contact_name', limit: 255
      t.string 'contact_email', limit: 255
      t.string 'contact_number', limit: 255
      t.string 'duns', limit: 255
      t.string 'registration_number', limit: 255
      t.string 'address_line_1', limit: 255
      t.string 'address_line_2', limit: 255
      t.string 'address_town', limit: 255
      t.string 'address_county', limit: 255
      t.string 'address_postcode', limit: 255
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['user_id'], name: 'index_facilities_management_supplier_details_on_user_id'
    end

    rename_table :fm_suppliers, :facilities_management_supplier_details
  end
end
