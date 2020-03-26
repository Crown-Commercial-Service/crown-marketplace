class AddContractNumberToFacilitiesManagementProcurementSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_suppliers, :contract_number, :string
  end
end
