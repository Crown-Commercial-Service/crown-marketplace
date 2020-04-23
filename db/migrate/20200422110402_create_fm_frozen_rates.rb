class CreateFmFrozenRates < ActiveRecord::Migration[5.2]
  def change
    create_table :fm_frozen_rates, id: :uuid, force: true do |t|
      t.references :facilities_management_procurement,
                   foreign_key: true, type: :uuid, null: false,
                   index: { name: 'index_frozen_fm_rates_procurement' }

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
