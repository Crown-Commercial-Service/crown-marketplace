require 'rake'
module SupplyTeachers
  class DataScriptWorker
    include Sidekiq::Worker

    def perform(upload_id)
      upload = SupplyTeachers::Admin::Upload.find(upload_id)
      Rake::Task.clear
      Rails.application.load_tasks
      Rake::Task['st:clean'].invoke
      Rake::Task['st:data'].invoke

      if File.zero?('./lib/tasks/supply_teachers/output/errors.out')
        upload.review!
      else
        file = File.open('./lib/tasks/supply_teachers/output/errors.out')
        fail_upload(upload, 'There is an error with your files: ' + file.read)
      end
    rescue StandardError => e
      fail_upload(SupplyTeachers::Admin::Upload.find(upload_id), 'There is an error with your files. Please try again. ' + e.message)
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end
  end
end
