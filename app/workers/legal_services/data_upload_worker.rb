require 'json'

module LegalServices
  class DataUploadWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'default'

    def perform(upload_id)
      upload = LegalServices::Admin::Upload.find(upload_id)
      suppliers = upload.data

      LegalServices::Upload.upload!(suppliers)
      upload.complete!
    rescue ActiveRecord::RecordInvalid => e
      summary = {
        record: e.record,
        record_class: e.record.class.to_s,
        errors: e.record.errors
      }

      fail_upload(LegalServices::Admin::Upload.find(upload_id), summary)
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end
  end
end
