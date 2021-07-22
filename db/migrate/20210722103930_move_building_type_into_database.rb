class MoveBuildingTypeIntoDatabase < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_building_types, id: :string, index: true do |t|
      t.text :title, null: false
      t.text :description
      t.boolean :standard_building_type
      t.integer :sort_order
      t.timestamps null: true
    end
  end
end
