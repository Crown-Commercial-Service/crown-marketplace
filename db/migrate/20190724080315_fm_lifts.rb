class FmLifts < ActiveRecord::Migration[5.2]
  def change
    return if table_exists?('fm_lifts')

    create_table 'fm_lifts', id: false do |t|
      t.text 'user_id', null: false
      t.text 'building_id', null: false
      t.jsonb 'lift_data', null: false
      t.timestamps
      t.index "((lift_data -> 'floor-data'::text))", name: 'fm_lifts_lift_json', using: :gin
      t.index %w[user_id building_id], name: 'fm_lifts_user_id_idx'
    end
  end
end
