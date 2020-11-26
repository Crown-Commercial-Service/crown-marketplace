class RemoveExtraSpreadsheetImports < ActiveRecord::Migration[5.2]
  def up
    FacilitiesManagement::SpreadsheetImport.order(:updated_at).group_by(&:facilities_management_procurement_id).each do |_, spreadhseet_imports|
      next if spreadhseet_imports.count == 1

      spreadhseet_imports[0..-2].each do |spreadhseet_import|
        spreadhseet_import.remove_spreadsheet_file
        spreadhseet_import.delete
      end
    end
  end

  def down; end
end
