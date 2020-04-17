class AddContractDateTimeToFacilitiesManagementProcurement < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :contract_datetime, :string
  end
end
