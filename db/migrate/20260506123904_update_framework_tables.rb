class UpdateFrameworkTables < ActiveRecord::Migration[8.1]
  def change
    create_table :admin_uploads, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: true, null: false
      t.references :framework, type: :text, foreign_key: true, index: true, null: false

      t.string :aasm_state, limit: 30
      t.text :import_errors

      t.timestamps
    end

    change_table :positions, bulk: true do |t|
      t.text :rate_type
      t.boolean :mandatory
    end

    change_table :suppliers, bulk: true do |t|
      t.jsonb :additional_details
    end

    add_index :suppliers, "(additional_details->'trading_name')", unique: true, name: 'index_suppliers_on_additional_details_trading_name'
    add_index :suppliers, "(additional_details->'additional_identifier')", unique: true, name: 'index_suppliers_on_additional_details_additional_identifier'
  end
end
