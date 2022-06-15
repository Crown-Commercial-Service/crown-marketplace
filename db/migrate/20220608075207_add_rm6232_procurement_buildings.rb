class AddRM6232ProcurementBuildings < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_procurement_buildings, id: :uuid do |t|
      t.references :facilities_management_rm6232_procurement, type: :uuid, index: { name: 'index_procurement_building_on_fm_rm6232_procurements_id' }, foreign_key: true
      t.references :facilities_management_building, type: :uuid, index: { name: 'index_building_on_fm_rm6232_procurements_id' }, foreign_key: true
      t.boolean :active, index: { name: 'index_fm_rm6232_procurement_buildings_on_active' }, foreign_key: true
      t.text :service_codes, default: [], array: true

      t.timestamps
    end

    rename_column :facilities_management_rm6232_procurement_buildings, :facilities_management_building_id, :building_id
  end
end
