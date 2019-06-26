require 'rake'
require 'aws-sdk-s3'

module ManagementConsultancy
  class DataScriptWorker
    include Sidekiq::Worker

    def perform(upload_id)
      upload = ManagementConsultancy::Admin::Upload.find(upload_id)
      Rake::Task.clear
      Rails.application.load_tasks
      Rake::Task['mc:clean'].invoke
      Rake::Task['mc:data'].invoke

      begin
        if File.zero?('./storage/management_consultancy/current_data/output/errors.out')
          upload.review!
        else
          file = File.open('./storage/management_consultancy/current_data/output/errors.out')
          fail_upload(upload, 'There is an error with your files: ' + file.read)
        end
      rescue StandardError => e
        fail_upload(ManagementConsultancy::Admin::Upload.find(upload_id), 'There is an error with your files. Please try again. ' + e.message)
      end
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end
  end
end
