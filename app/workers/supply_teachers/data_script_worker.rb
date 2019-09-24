require 'rake'
require 'aws-sdk-s3'

module SupplyTeachers
  class DataScriptWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'st'

    def perform(upload_id)
      @upload = SupplyTeachers::Admin::Upload.find(upload_id)
      Rake::Task.clear
      Rails.application.load_tasks
      Rake::Task['st:clean'].invoke
      Rake::Task['st:data'].invoke

      check_for_errors
    rescue StandardError => e
      fail_upload(@upload, e.message)
    end

    private

    def check_for_errors
      if SupplyTeachers::Admin::CurrentData.first.error.empty?
        @upload.review!
      else
        fail_upload(@upload, SupplyTeachers::Admin::CurrentData.first.error)
      end
    end

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end
  end
end
