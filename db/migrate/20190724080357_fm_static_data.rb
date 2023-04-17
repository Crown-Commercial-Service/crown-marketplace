class FmStaticData < ActiveRecord::Migration[5.2]
  def change
    return if table_exists?(:fm_static_data)

    create_table :fm_static_data, id: false do |t|
      t.text 'key', null: false
      t.jsonb 'value'
      t.index ['key'], name: 'fm_static_data_key_idx'
    end
  end
end
