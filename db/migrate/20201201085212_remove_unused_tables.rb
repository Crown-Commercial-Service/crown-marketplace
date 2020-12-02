class RemoveUnusedTables < ActiveRecord::Migration[5.2]
  def change
    drop_table 'fm_uom_values', id: false, force: :cascade do |t|
      t.text 'user_id'
      t.text 'service_code'
      t.text 'uom_value'
      t.text 'building_id'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index ['user_id', 'service_code', 'building_id'], name: 'fm_uom_values_user_id_idx'
    end

    drop_table 'fm_lifts', id: false, force: :cascade do |t|
      t.text 'user_id', null: false
      t.text 'building_id', null: false
      t.jsonb 'lift_data', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.index "((lift_data -> 'floor-data'::text))", name: 'fm_lifts_lift_json', using: :gin
      t.index ['user_id', 'building_id'], name: 'fm_lifts_user_id_idx'
    end
  end
end
