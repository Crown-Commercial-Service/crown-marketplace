class SetCurrentProcurementMonthsToZero < ActiveRecord::Migration[5.2]
  class Procurement < ApplicationRecord
    self.table_name = 'facilities_management_procurements'
  end

  # rubocop:disable Rails/SkipsModelValidations
  def up
    Procurement.reset_column_information

    Procurement.where(aasm_state: %w[choose_contract_value results da_draft direct_award further_competition closed]).update_all(initial_call_off_period_months: 0)
  end
  # rubocop:enable Rails/SkipsModelValidations

  def down; end
end
