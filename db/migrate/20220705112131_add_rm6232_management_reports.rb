class AddRM6232ManagementReports < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_admin_management_reports, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: true, index: { name: 'index_fm_rm6232_management_reports_on_user_id' }
      t.string :aasm_state, limit: 30
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
