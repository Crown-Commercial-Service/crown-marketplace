class CreateFacilitiesManagementProcurementBuildings < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_procurement_buildings, id: :uuid do |t|
      t.references :facilities_management_procurement,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_fm_procurements_on_fm_procurement_id' }
      t.text :service_codes, default: [], array: true
      t.string :name, limit: 255
      t.timestamps
    end
  end
end
