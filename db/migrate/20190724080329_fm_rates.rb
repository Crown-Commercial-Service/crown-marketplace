class FmRates < ActiveRecord::Migration[5.2]
  def change
    return if table_exists?(:fm_rates)

    create_table 'fm_rates', id: false do |t|
      t.text 'code', limit: 255
      t.decimal 'framework'
      t.decimal 'benchmark'
      t.index ['code'], name: 'fm_rates_code_key', unique: true
      t.datetime 'created_at', default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime 'updated_at', default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
