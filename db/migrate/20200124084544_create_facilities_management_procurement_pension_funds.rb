class CreateFacilitiesManagementProcurementPensionFunds < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_procurement_pension_funds, id: :uuid do |t|
      t.references :facilities_management_procurement,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_fm_procurement_pension_funds_on_fm_procurement_id' }
      t.string :name, limit: 150
      t.integer :percentage, min: 1, max: 100
      t.timestamps
    end
  end
end
