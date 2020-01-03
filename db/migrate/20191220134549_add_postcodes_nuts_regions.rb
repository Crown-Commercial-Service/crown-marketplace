class AddPostcodesNutsRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :postcodes_nuts_regions, id: :uuid, force: :cascade do |t|
      t.string :postcode, limit: 255
      t.string :code, limit: 255
      t.timestamps
    end
  end
end
