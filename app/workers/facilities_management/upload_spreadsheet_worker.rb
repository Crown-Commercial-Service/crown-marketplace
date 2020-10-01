module FacilitiesManagement
  class UploadSpreadsheetWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'bulkupload', retry: true

    def perform(id)
      spreadsheet_import = SpreadsheetImport.find(id)
      FacilitiesManagement::SpreadsheetImporter.new(spreadsheet_import).import_data
    rescue ActiveRecord::RecordNotFound => e
      logger.error e.message
    end
  end
end
