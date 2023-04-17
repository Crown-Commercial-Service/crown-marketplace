class CreateLondonPostcodes < ActiveRecord::Migration[5.2]
  def change
    create_table :london_postcodes, id: false, force: :cascade do |t|
      t.text :postcode
      t.text 'In Use'
      t.text :region
      t.text 'Last updated'
    end
  end
end
