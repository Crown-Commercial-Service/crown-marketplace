class AddGenericFrameworksTable < ActiveRecord::Migration[6.1]
  def change
    create_table :frameworks, id: :uuid do |t|
      t.string :service, limit: 25
      t.string :framework, limit: 6
      t.date :live_at
      t.date :expires_at
      t.timestamps
    end
  end
end
