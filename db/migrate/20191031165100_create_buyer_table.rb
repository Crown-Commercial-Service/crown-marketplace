# rubocop:disable Style/GuardClause
class CreateBuyerTable < ActiveRecord::Migration[5.2]
  def change
    unless table_exists?(:facilities_management_buyer)
      create_table 'facilities_management_buyer', id: false, force: :cascade do |t|
        t.uuid 'id', null: false
        t.string 'full_name', limit: 50
        t.string 'job_title', limit: 250
        t.string 'telephone_number', limit: 100
        t.string 'organisation_name', limit: 250
        t.text 'organisation_address_line_1'
        t.text 'organisation_address_line_2'
        t.text 'organisation_address_town'
        t.text 'organisation_address_county'
        t.text 'organisation_address_postcode'
        t.boolean 'central_government'
        t.boolean 'wider_public_sector'
        t.datetime 'created_at', default: -> { 'now()' }
        t.datetime 'updated_at'
        t.boolean 'active', default: true, null: false
        t.text 'email', null: false
        t.index ['id'], name: 'facilities_management_buyer_id_idx'
        t.index ['email'], name: 'facilities_management_buyer_email_idx'
      end
    end
  end
end
# rubocop:enable Style/GuardClause
