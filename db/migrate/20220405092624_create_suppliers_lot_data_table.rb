class CreateSuppliersLotDataTable < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_supplier_lot_data, id: :uuid do |t|
      t.references :facilities_management_rm6232_supplier, foreign_key: true, type: :uuid, index: { name: 'index_fm_rm6232_supplier_lot_data_on_fm_rm6232_supplier_id' }
      t.string :lot_code, limit: 1, index: { name: 'index_fm_rm6232_supplier_lot_data_on_lot_number' }
      t.text :service_codes, array: true, default: []
      t.text :region_codes, array: true, default: []
      t.timestamps
    end
  end
end
