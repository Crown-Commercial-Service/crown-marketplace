class CreateLegalServicesUploads < ActiveRecord::Migration[5.2]
  # rubocop:disable Style/SymbolProc
  def change
    create_table :legal_services_uploads, id: :uuid do |t|
      t.timestamps
    end
  end
  # rubocop:enable Style/SymbolProc
end
