class AddProcurementTable < ActiveRecord::Migration[8.0]
  def change
    create_table :procurements, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: true, null: false
      t.references :framework, type: :text, foreign_key: true, null: false
      t.references :lot, type: :text, foreign_key: true, null: false

      t.jsonb :procurement_details

      t.text :contract_name, limit: 115
      t.text :contract_number

      t.index %i[contract_name user_id framework_id], unique: true

      t.timestamps
    end
  end
end
