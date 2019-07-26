class FmSuppliers < ActiveRecord::Migration[5.2]
  def change
    return if table_exists?('fm_suppliers')

    create_table 'fm_suppliers', primary_key: 'supplier_id', id: :uuid, default: nil do |t|
      t.jsonb 'data'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.timestamps
      t.index "((data -> 'lots'::text))", name: 'idxginlots', using: :gin
      t.index ['data'], name: 'idxgin', using: :gin
      t.index ['data'], name: 'idxginp', opclass: :jsonb_path_ops, using: :gin
    end
  end
end
