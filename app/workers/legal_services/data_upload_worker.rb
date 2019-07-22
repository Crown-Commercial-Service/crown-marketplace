require 'rake'
require 'aws-sdk-s3'

module LegalServices
  class DataUploadWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'ls'

    def perform(upload_id)
      upload = LegalServices::Admin::Upload.find(upload_id)
      suppliers = JSON.parse(File.read(URI.open(data_file)))

      LegalServices::Upload.upload!(suppliers)

      upload.approve!
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

    def data_file
      if Rails.env.development?
        Rails.root.join('storage', 'legal_services', 'current_data', 'output', 'data.json')
      else
        "https://s3-#{ENV['COGNITO_AWS_REGION']}.amazonaws.com/#{ENV['CCS_APP_API_DATA_BUCKET']}/management_consultancy/current_data/output/data.json"
      end
    end
  end
end
