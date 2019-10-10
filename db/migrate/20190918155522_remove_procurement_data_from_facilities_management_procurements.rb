class RemoveProcurementDataFromFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    remove_column :facilities_management_procurements, :procurement_data, :jsonb
  end
end
