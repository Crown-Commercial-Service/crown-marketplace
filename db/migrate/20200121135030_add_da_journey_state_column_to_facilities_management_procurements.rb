class AddDaJourneyStateColumnToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :da_journey_state, :string
  end
end
