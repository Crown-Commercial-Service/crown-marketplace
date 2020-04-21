class AddContractNumberToFacilitiesManagementProcurement < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :contract_number, :string
  end
end
