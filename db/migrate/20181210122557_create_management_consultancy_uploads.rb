class CreateManagementConsultancyUploads < ActiveRecord::Migration[5.2]
  # rubocop:disable Style/SymbolProc
  def change
    create_table :management_consultancy_uploads, id: :uuid do |t|
      t.timestamps
    end
  end
  # rubocop:enable Style/SymbolProc
end
