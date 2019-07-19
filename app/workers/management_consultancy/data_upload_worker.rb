require 'rake'

module ManagementConsultancy
  class DataUploadWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'mc'

    def perform(upload_id)
      upload = ManagementConsultancy::Admin::Upload.find(upload_id)
      suppliers = JSON.parse(File.read(upload.suppliers_data.file.path))

      ManagementConsultancy::Upload.upload!(suppliers)

      upload.upload!
    rescue ActiveRecord::RecordInvalid => e
      summary = {
        record: e.record,
        record_class: e.record.class.to_s,
        errors: e.record.errors
      }

      fail_upload(ManagementConsultancy::Admin::Upload.find(upload_id), summary)
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end
  end
end
