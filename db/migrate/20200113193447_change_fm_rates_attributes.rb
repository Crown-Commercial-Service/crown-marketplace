class ChangeFmRatesAttributes < ActiveRecord::Migration[5.2]
  def change
    # recreating fm_rates table with force:true so it removes the previous table first
    create_table :fm_rates, id: :uuid, force: true do |t|
      t.string :code, limit: 5
      t.decimal :framework
      t.decimal :benchmark
      t.string :standard, limit: 1
      t.boolean :direct_award

      t.datetime 'created_at', default: -> { 'CURRENT_TIMESTAMP' }
      t.datetime 'updated_at', default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
