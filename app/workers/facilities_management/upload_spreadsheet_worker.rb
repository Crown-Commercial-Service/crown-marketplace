module FacilitiesManagement
  class UploadSpreadsheetWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: true

    def perform(id)
      spreadsheet_import = SpreadsheetImport.find(id)
      FacilitiesManagement::SpreadsheetImporter.new(spreadsheet_import).import_data
    end
  end
end
