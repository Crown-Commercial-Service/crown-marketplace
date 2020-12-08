class CreateManagementReport < ActiveRecord::Migration[5.2]
  def change
    create_table :facilities_management_management_reports, id: :uuid do |t|
      t.date :start_date
      t.date :end_date
      t.string :aasm_state, limit: 30
      t.references :user, foreign_key: true, type: :uuid, null: false

      t.timestamps
    end
  end
end
