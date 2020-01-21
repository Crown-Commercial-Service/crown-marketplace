class AddContractClosedInformationToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :closed_contract_date, :date
    add_column :facilities_management_procurements, :is_contract_closed, :boolean
  end
end
