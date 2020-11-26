class AddErrorsOnSpreadsheetImport < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_spreadsheet_imports, :import_errors, :json, default: {}
  end
end
