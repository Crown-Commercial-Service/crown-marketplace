class AddDataImportStateToSpreadsheetImport < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities_management_spreadsheet_imports, :data_import_state, :string, limit: 30
  end
end
