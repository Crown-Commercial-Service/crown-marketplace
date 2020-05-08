class ChangeRecordIdToBeUuidInChangeActiveStorageAttachments < ActiveRecord::Migration[5.2]
  def up
    remove_column :active_storage_attachments, :record_id, :bigint
    add_column :active_storage_attachments, :record_id, :uuid
  end

  def down
    remove_column :active_storage_attachments, :record_id, :uuid
    add_column :active_storage_attachments, :record_id, :bigint
  end
end
