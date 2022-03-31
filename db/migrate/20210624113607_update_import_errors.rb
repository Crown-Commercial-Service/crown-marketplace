# rubocop:disable Rails/ReversibleMigration
class UpdateImportErrors < ActiveRecord::Migration[6.0]
  def change
    change_column :facilities_management_admin_uploads, :import_errors, :text, default: nil
  end
end
# rubocop:enable Rails/ReversibleMigration
