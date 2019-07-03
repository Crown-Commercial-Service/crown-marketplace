class CreateCcsFmRateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :fm_rate_cards do |t|
      t.jsonb :data

      t.text :source_file, null: false

      t.timestamps
    end

    execute 'CREATE INDEX IF NOT EXISTS idxgin ON fm_suppliers USING GIN (data)'
 
  end
end

