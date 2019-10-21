class CreateFacilitiesManagementProcurementBuildingService < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_procurement_building_services do |t|
      t.references :facilities_management_procurement_building,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_fm_procurements_on_fm_procurement_building_id' }
      t.string :code, limit: 10
      t.string :name, limit: 255
      t.timestamps
    end
  end
end
