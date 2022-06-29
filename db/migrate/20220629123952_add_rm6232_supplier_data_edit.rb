class AddRM6232SupplierDataEdit < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_admin_supplier_data_edits, id: :uuid do |t|
      t.references :facilities_management_rm6232_admin_supplier_data, foreign_key: true, type: :uuid, null: false, index: { name: 'index_fm_rm6232_admin_sd_edits_on_fm_rm6232_admin_sd_id ' }
      t.references :user, type: :uuid, foreign_key: true, index: { name: 'index_fm_rm6232_admin_sd_edits_on_user_id' }

      t.uuid :supplier_id
      t.string :change_type, limit: 255
      t.json :data

      t.timestamps
    end
  end
end
