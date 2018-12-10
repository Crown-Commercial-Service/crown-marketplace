class CreateFacilitiesManagementUploads < ActiveRecord::Migration[5.2]
  # rubocop:disable Style/SymbolProc
  def change
    create_table :facilities_management_uploads, id: :uuid do |t|
      t.timestamps
    end
  end
  # rubocop:enable Style/SymbolProc
end
