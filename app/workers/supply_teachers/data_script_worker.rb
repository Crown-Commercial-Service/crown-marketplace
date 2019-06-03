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

      if File.zero?('./storage/supply_teachers/output/errors.out')
        upload.review!
      else
        file = File.open('./storage/supply_teachers/output/errors.out')
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
