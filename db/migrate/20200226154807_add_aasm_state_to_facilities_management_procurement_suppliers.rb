class AddAasmStateToFacilitiesManagementProcurementSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurement_suppliers, :aasm_state, :string, limit: 30
    add_column :facilities_management_procurement_suppliers, :offer_sent_date, :datetime
    add_column :facilities_management_procurement_suppliers, :supplier_response_date, :datetime
    add_column :facilities_management_procurement_suppliers, :contract_start_date, :datetime
    add_column :facilities_management_procurement_suppliers, :contract_end_date, :datetime
    add_column :facilities_management_procurement_suppliers, :contract_signed_date, :datetime
    add_column :facilities_management_procurement_suppliers, :contract_closed_date, :datetime
    add_column :facilities_management_procurement_suppliers, :reason_for_closing, :text
  end
end
