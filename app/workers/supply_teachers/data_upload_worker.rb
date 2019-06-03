require 'rake'
module SupplyTeachers
  class DataUploadWorker
    include Sidekiq::Worker

    def perform(upload_id)
      upload = SupplyTeachers::Admin::Upload.find(upload_id)
      suppliers = JSON.parse(File.read(data_file))

      SupplyTeachers::Upload.upload!(suppliers)

      upload.approve!
    rescue ActiveRecord::RecordInvalid => e
      summary = {
        record: e.record,
        record_class: e.record.class.to_s,
        errors: e.record.errors
      }

      fail_upload(SupplyTeachers::Admin::Upload.find(upload_id), summary)
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end

    def data_file
      # always use anonymous.json for now - need to set this up for production to use data.json
      './storage/supply_teachers/output/anonymous.json'
    end
  end
end
