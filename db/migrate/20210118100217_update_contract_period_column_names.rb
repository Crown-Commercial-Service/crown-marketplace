class UpdateContractPeriodColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :facilities_management_procurements, :initial_call_off_period, :initial_call_off_period_years
    add_column :facilities_management_procurements, :initial_call_off_period_months, :integer
  end
end
