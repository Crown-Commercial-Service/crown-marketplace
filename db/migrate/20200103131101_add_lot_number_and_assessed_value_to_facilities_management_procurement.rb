class AddLotNumberAndAssessedValueToFacilitiesManagementProcurement < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :lot_number, :string
    add_column :facilities_management_procurements, :assessed_value, :money
  end
end
