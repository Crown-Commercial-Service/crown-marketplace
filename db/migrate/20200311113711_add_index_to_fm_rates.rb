class AddIndexToFmRates < ActiveRecord::Migration[5.2]
  def change
    add_index :fm_rates, :code, name: 'index_fm_rates_on_code' unless index_exists?(:fm_rates, :code, name: 'index_fm_rates_on_code')
  end
end
