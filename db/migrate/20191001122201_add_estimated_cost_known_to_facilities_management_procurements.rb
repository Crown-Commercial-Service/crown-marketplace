class AddEstimatedCostKnownToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :estimated_cost_known, :boolean
  end
end
