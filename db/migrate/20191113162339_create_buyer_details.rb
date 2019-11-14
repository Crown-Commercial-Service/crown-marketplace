class CreateBuyerDetails < ActiveRecord::Migration[5.2]
  def change
    drop_table :facilities_management_buyer if table_exists?(:facilities_management_buyer)

    create_table :facilities_management_buyer_details do |t|
      t.references :user
      t.string :full_name, limit: 255
      t.string :job_title, limit: 255
      t.string :telephone_number, limit: 255
      t.string :organisation_name, limit: 255
      t.string :organisation_address_line_1, limit: 255
      t.string :organisation_address_line_2, limit: 255
      t.string :organisation_address_town, limit: 255
      t.string :organisation_address_county, limit: 255
      t.string :organisation_address_postcode, limit: 255
      t.boolean :central_government
      t.boolean :wider_public_sector
      t.boolean :active
      t.string :email, limit: 255

      t.timestamps
    end
  end
end
