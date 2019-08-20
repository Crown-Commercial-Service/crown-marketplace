class FmCache < ActiveRecord::Migration[5.2]
  def change
    return if table_exists?('fm_cache')

    create_table 'fm_cache', id: false do |t|
      t.text 'user_id', null: false
      t.text 'key', null: false
      t.text 'value'
      t.timestamps
      t.index %w[user_id key], name: 'fm_cache_user_id_idx'
    end
  end
end
