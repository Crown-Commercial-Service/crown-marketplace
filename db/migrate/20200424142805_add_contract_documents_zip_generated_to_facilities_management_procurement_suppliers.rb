class AddContractDocumentsZipGeneratedToFacilitiesManagementProcurementSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_suppliers, :contract_documents_zip_generated, :boolean
  end
end
