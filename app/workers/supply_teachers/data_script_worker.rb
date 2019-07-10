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
      error_file_path = Rails.env.development? ? Rails.root.join('storage', 'supply_teachers', 'current_data', 'output', 'errors.out') : "https://s3-#{ENV['COGNITO_AWS_REGION']}.amazonaws.com/#{ENV['CCS_APP_API_DATA_BUCKET']}/supply_teachers/current_data/output/errors.out"
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
