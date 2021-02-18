class CreateFacilitiesManagementProcurementOptionalCallOffExtensions < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_procurement_optional_call_off_extensions, id: :uuid do |t|
      t.references :facilities_management_procurement, type: :uuid, index: { name: 'index_optional_call_off_on_fm_procurements_id' }, foreign_key: true
      t.integer :extension
      t.integer :years
      t.integer :months

      t.timestamps
    end
  end
end
