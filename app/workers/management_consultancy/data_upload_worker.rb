require 'rake'
require 'aws-sdk-s3'

module ManagementConsultancy
  class DataUploadWorker
    include Sidekiq::Worker

    def perform(upload_id)
      upload = ManagementConsultancy::Admin::Upload.find(upload_id)
      suppliers = JSON.parse(File.read(data_file))

      ManagementConsultancy::Upload.upload!(suppliers)

      upload.approve!
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

    def data_file
      file_path = './storage/management_consultancy/current_data/output/data.json'
      if Rails.env.production?
        object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
        object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object('management_consultancy/current_data/output/data.json').get(response_target: file_path)
      end
      file_path
    end
  end
end
