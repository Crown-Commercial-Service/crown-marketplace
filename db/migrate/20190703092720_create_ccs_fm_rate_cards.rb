class CreateCcsFmRateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :fm_rate_cards do |t|
      t.jsonb :data

      t.timestamps
    end
  end
end
