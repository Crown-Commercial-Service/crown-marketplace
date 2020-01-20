class AddIndexToPostcodesNutsRegions < ActiveRecord::Migration[5.2]
  def change
    ActiveRecord::Base.connection.execute('TRUNCATE postcodes_nuts_regions')
    add_index :postcodes_nuts_regions, :postcode, unique: true
    change_column :postcodes_nuts_regions, :postcode, :string, limit: 20
    change_column :postcodes_nuts_regions, :code, :string, limit: 20
  end
end
