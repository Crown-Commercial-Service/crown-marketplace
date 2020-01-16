class AddEligibleForDaToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :eligible_for_da, :boolean
  end
end
