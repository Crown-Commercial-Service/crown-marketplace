module Admin
  class FileUploadWorker
    include Sidekiq::Worker

    def perform(id)
      import = self.class.module_parent::Upload.find(id)
      self.class.module_parent::FilesImporter.new(import).import_data
    rescue ActiveRecord::RecordNotFound => e
      logger.error e.message
    end
  end
end
