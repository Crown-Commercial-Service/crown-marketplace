class AddLiftsAsNestedAttribute < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_procurement_building_service_lifts, id: :uuid do |t|
      t.references :facilities_management_procurement_building_services,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_fmpbs_procurement_lifts_on_fmp_building_services_id' }
      t.integer :number_of_floors, min: 1, max: 100
      t.timestamps
    end
  end
end
