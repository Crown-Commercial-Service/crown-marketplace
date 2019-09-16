class AddSecurityTypeTable < ActiveRecord::Migration[5.2]
  def up
    unless ActiveRecord::Base.connection.table_exists?('fm_security_types')
      create_table :fm_security_types, id: :uuid, if_not_exists: true do |t|
        t.text :title, null: false
        t.text :description
        t.integer :sort_order
        t.timestamps null: true
      end

      add_index :fm_security_types, :id
    end

    change_column_default :fm_security_types, :created_at, 'now()'
    change_column_default :fm_security_types, :updated_at, 'now()'
  end

  def down
    drop_table :fm_security_types
  end
end
