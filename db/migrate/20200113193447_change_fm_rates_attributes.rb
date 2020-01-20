class ChangeFmRatesAttributes < ActiveRecord::Migration[5.2]
  def up
    add_column :fm_rates, :standard, :string, limit: 1
    add_column :fm_rates, :direct_award, :boolean
    change_column :fm_rates, :code, :string, unique: false, limit: 5
    remove_foreign_key(:fm_rates, name: 'fm_rates_code_key') if foreign_key_exists?(:fm_rates, name: 'fm_rates_code_key')
    remove_index :fm_rates, ['code'] if index_exists?(:fm_rates, ['code'])
    remove_index :fm_rates, name: 'fm_rates_code_key' if index_exists?(:fm_rates, name: 'fm_rates_code_key')
    add_index :fm_rates, ['code'], unique: false
  end

  def down
    remove_column :fm_rates, :standard, :string
    remove_column :fm_rates, :direct_award, :boolean
    change_column :fm_rates, :code, :text
    remove_index :fm_rates, ['code']
    add_index :fm_rates, ['code']
  end
end
