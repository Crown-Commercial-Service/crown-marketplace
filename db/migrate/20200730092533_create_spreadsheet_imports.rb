class CreateSpreadsheetImports < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_spreadsheet_imports, id: :uuid do |t|
      t.references :facilities_management_procurement, foreign_key: true, type: :uuid, null: false, index: { name: 'index_fm_procurements_on_fm_spreadsheet_imports_id' }
      t.string :aasm_state, limit: 15
      t.string :spreadsheet_file, limit: 255

      t.timestamps
    end
  end
end
