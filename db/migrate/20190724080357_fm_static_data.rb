class FmStaticData < ActiveRecord::Migration[5.2]
  def change
    create_table 'fm_static_data', id: false do |t|
      t.text 'key', null: false
      t.jsonb 'value'
      t.timestamps
      t.index ['key'], name: 'fm_static_data_key_idx'
    end
  end
end
