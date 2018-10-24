class AddDailyFeeToRates < ActiveRecord::Migration[5.2]
  def change
    add_column :rates, :daily_fee, :money
    change_column_null :rates, :mark_up, true
  end
end
