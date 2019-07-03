require 'rake'
require 'aws-sdk-s3'

module SupplyTeachers
  class DataScriptWorker
    include Sidekiq::Worker

    def perform(upload_id)
      upload = SupplyTeachers::Admin::Upload.find(upload_id)
      Rake::Task.clear
      Rails.application.load_tasks
      Rake::Task['st:clean'].invoke
      Rake::Task['st:data'].invoke
      # object = Aws::S3::Resource.new(region: ENV['COGNITO_AWS_REGION'])
      error_file_path = Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', 'errors.out')
      # object.bucket(ENV['CCS_APP_API_DATA_BUCKET']).object('supply_teachers/current_data/output/errors.out').get(response_target: error_file_path)

      if File.zero?(error_file_path)
        upload.review!
      else
        file = File.open(error_file_path)
        fail_upload(upload, file.read)
      end
    rescue StandardError => e
      fail_upload(SupplyTeachers::Admin::Upload.find(upload_id), e.full_message)
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end
  end
end
