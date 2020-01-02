class AddFacilitiesManagementProcurementSupplier < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_procurement_suppliers, id: :uuid do |t|
      t.references :facilities_management_procurement,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_fm_procurement_supplier_on_fm_procurement_id' }
      t.uuid :supplier_id
      t.money :direct_award_value, null: false
      t.timestamps
    end
  end
end
