module LegalServices
  class DataScriptWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'default'

    def perform(upload_id)
      LegalServices::DataTransformationService.new(upload_id).run
    end
  end
end
