module FacilitiesManagement
  module RM3830
    class UploadSpreadsheetWorker
      include Sidekiq::Worker

      sidekiq_options queue: 'fm', retry: true

      def perform(id)
        spreadsheet_import = SpreadsheetImport.find(id)
        SpreadsheetImporter.new(spreadsheet_import).import_data
      rescue ActiveRecord::RecordNotFound => e
        logger.error e.message
      end
    end
  end
end
