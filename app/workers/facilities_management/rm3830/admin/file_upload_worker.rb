module FacilitiesManagement
  module RM3830
    module Admin
      class FileUploadWorker
        include Sidekiq::Worker

        sidekiq_options queue: 'fm', retry: false

        def perform(id)
          fm_import = Upload.find(id)
          FilesImporter.new(fm_import).import_data
        rescue ActiveRecord::RecordNotFound => e
          logger.error e.message
        end
      end
    end
  end
end
