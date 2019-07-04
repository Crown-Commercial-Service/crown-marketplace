class CreateCcsFmRateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :fm_rate_cards, id: :uuid do |t|
      t.jsonb :data

      t.text :source_file, null: false

      t.timestamps

      # execute 'CREATE INDEX IF NOT EXISTS idxgin ON fm_suppliers USING GIN (data)'
      t.index ['data'], name: 'idxgin', using: :gin
      t.index ['data'], name: 'idxginp', opclass: :jsonb_path_ops, using: :gin
    end
  end
end
