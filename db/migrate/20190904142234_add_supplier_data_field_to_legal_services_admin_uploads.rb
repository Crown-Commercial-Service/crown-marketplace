class AddSupplierDataFieldToLegalServicesAdminUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :legal_services_admin_uploads, :suppliers_data, :string
  end
end
