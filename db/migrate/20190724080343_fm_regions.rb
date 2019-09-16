class FmRegions < ActiveRecord::Migration[5.2]
  def change
    return if table_exists?('fm_regions')

    create_table :fm_regions, id: false do |t|
      t.text 'code', limit: 255
      t.text 'name', limit: 255
      t.timestamps null: true
      t.index ['code'], name: 'fm_regions_code_key', unique: true
    end

    change_column_default :fm_regions, :created_at, from: '', to: 'now()'
    change_column_default :fm_regions, :updated_at, from: '', to: 'now()'
  end
end
