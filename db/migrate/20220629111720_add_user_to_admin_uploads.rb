class AddUserToAdminUploads < ActiveRecord::Migration[6.0]
  def change
    add_reference :facilities_management_rm6232_admin_uploads, :user, type: :uuid, foreign_key: true, index: { name: 'index_fm_rm6232_uploads_on_users_id' }
    add_reference :facilities_management_rm3830_admin_uploads, :user, type: :uuid, foreign_key: true, index: { name: 'index_fm_rm3830_uploads_on_users_id' }
  end
end
