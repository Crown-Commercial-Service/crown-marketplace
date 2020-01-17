class ChangeFmRatesAttributes < ActiveRecord::Migration[5.2]
  def up
    add_column :fm_rates, :standard, :string, limit: 1
    add_column :fm_rates, :direct_award, :boolean
    change_column :fm_rates, :code, :string, unique: false, limit: 5
    remove_index :fm_rates, ['code']
    add_index :fm_rates, ['code'], unique: false
  end

  def down
    remove_column :fm_rates, :standard, :string
    remove_column :fm_rates, :direct_award, :boolean
    change_column :fm_rates, :code, :text
    remove_index :fm_rates, ['code']
    add_index :fm_rates, ['code'], unique: true
  end
end
