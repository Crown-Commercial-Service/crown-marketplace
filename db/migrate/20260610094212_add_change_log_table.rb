class AddChangeLogTable < ActiveRecord::Migration[8.1]
  def change
    create_table :change_logs, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: true, null: false
      t.references :framework, type: :text, foreign_key: true, index: true, null: false

      t.text :change_type
      t.jsonb :change_data

      t.timestamps
    end
  end
end
