class AddContractPeriodColumnsForRM6232 < ActiveRecord::Migration[6.0]
  def change
    add_column :facilities_management_rm6232_procurements, :initial_call_off_period_years, :integer
    add_column :facilities_management_rm6232_procurements, :initial_call_off_period_months, :integer
    add_column :facilities_management_rm6232_procurements, :initial_call_off_start_date, :date
    add_column :facilities_management_rm6232_procurements, :mobilisation_period_required, :boolean
    add_column :facilities_management_rm6232_procurements, :mobilisation_period, :integer
    add_column :facilities_management_rm6232_procurements, :extensions_required, :boolean
  end
end
