class DropTableLondonPostcodes < ActiveRecord::Migration[5.2]
  def up
    drop_table :london_postcodes
  end

  def down
    create_table :london_postcodes, id: false, force: :cascade do |t|
      t.text :postcode
      t.text 'In Use'
      t.text :region
      t.text 'Last updated'
    end
  end
end
