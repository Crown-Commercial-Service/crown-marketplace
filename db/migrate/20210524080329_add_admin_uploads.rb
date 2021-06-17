class AddAdminUploads < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_admin_uploads, id: :uuid do |t|
      t.string :aasm_state, limit: 30
      t.string :supplier_data_file, limit: 255
      t.text :import_errors, default: [], array: true
      t.timestamps
    end
  end
end
