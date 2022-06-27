class AddRM6232AdminUpload < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_admin_uploads, id: :uuid do |t|
      t.string :aasm_state, limit: 30
      t.string :supplier_details_file, limit: 255
      t.string :supplier_services_file, limit: 255
      t.string :supplier_regions_file, limit: 255
      t.text :import_errors
      t.timestamps
    end
  end
end
