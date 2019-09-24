class AddContractNameToFacilitiesManagementProcurements < ActiveRecord::Migration[5.2]
  def change
    add_column :facilities_management_procurements, :contract_name, :string, limit: 100
    add_column :facilities_management_procurements, :estimated_annual_cost, :integer
    add_column :facilities_management_procurements, :tupe, :boolean
    add_column :facilities_management_procurements, :initial_call_off_period, :integer
    add_column :facilities_management_procurements, :initial_call_off_start_date, :date
    add_column :facilities_management_procurements, :initial_call_off_end_date, :date
    add_column :facilities_management_procurements, :mobilisation_period, :integer
    add_column :facilities_management_procurements, :optional_call_off_extensions_1, :integer
    add_column :facilities_management_procurements, :optional_call_off_extensions_2, :integer
    add_column :facilities_management_procurements, :optional_call_off_extensions_3, :integer
    add_column :facilities_management_procurements, :optional_call_off_extensions_4, :integer
  end
end
