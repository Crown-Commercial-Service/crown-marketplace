class FmRates < ActiveRecord::Migration[5.2]
  def change
    create_table 'fm_rates', id: false do |t|
      t.text 'code', limit: 255
      t.decimal 'framework'
      t.decimal 'benchmark'
      t.timestamps
      t.index ['code'], name: 'fm_rates_code_key', unique: true
    end
  end
end
