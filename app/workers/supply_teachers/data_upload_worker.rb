require 'rake'
require 'aws-sdk-s3'

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
      object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      file_path = './storage/supply_teachers/current_data/output/anonymous.json'
      object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object('supply_teachers/current_data/output/anonymous.json').get(response_target: file_path)
      file_path
    end
  end
end
