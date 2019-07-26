class FmUomValues < ActiveRecord::Migration[5.2]
  def change
    return if table_exists?(:fm_uom_values)

    create_table 'fm_uom_values', id: true do |t|
      t.text 'user_id'
      t.text 'service_code'
      t.text 'uom_value'
      t.text 'building_id'
      t.timestamps
      t.index %w[user_id service_code building_id], name: 'fm_uom_values_user_id_idx'
    end
  end
end
