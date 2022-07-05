class AddRM6232RateCard < ActiveRecord::Migration[6.0]
  def change
    create_table :facilities_management_rm6232_admin_supplier_data, id: :uuid do |t|
      t.references :facilities_management_rm6232_admin_upload, foreign_key: true, type: :uuid, index: { name: 'index_fm_rm6232_supplier_data_on_fm_rm6232_admin_upload_id ' }
      t.json :data

      t.timestamps
    end
  end
end
