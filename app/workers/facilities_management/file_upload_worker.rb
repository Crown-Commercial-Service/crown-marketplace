module FacilitiesManagement
  class FileUploadWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'fm', retry: false

    def perform(id)
      fm_import = Admin::Upload.find(id)
      Admin::SupplierFrameworkDataImporter.new(fm_import).import_data
    rescue ActiveRecord::RecordNotFound => e
      logger.error e.message
    end
  end
end
