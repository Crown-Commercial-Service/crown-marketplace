class RemoveUnusedFileColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :facilities_management_rm3830_spreadsheet_imports, :spreadsheet_file, type: :string, limit: 255
    remove_column :facilities_management_rm3830_admin_uploads, :supplier_data_file, type: :string, limit: 255
    remove_column :facilities_management_rm6232_admin_uploads, :supplier_details_file, type: :string, limit: 255
    remove_column :facilities_management_rm6232_admin_uploads, :supplier_services_file, type: :string, limit: 255
    remove_column :facilities_management_rm6232_admin_uploads, :supplier_regions_file, type: :string, limit: 255
  end
end
