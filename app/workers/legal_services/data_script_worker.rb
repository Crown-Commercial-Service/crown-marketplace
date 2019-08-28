require 'rake'
require 'aws-sdk-s3'
require './lib/tasks/legal_services/scripts/add_suppliers'
require './lib/tasks/legal_services/scripts/add_lot_1_services_per_supplier'
require './lib/tasks/legal_services/scripts/add_lot_2_services_per_supplier'
require './lib/tasks/legal_services/scripts/add_lot_3_and_4_services_per_supplier'
require './lib/tasks/legal_services/scripts/add_rate_cards_to_suppliers'

module LegalServices
  class DataScriptWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'ls'

    def perform(upload_id)
      Rake::Task.clear
      Rails.application.load_tasks
      Rake::Task['ls:clean'].invoke
      add_suppliers(upload_id)
      add_lot_1_services_per_supplier(upload_id)
      add_lot_2_services_per_supplier(upload_id)
      add_lot_3_and_4_services_per_supplier(upload_id)
      add_rate_cards_to_suppliers(upload_id)

      upload = LegalServices::Admin::Upload.find(upload_id)
      upload.review!
    rescue StandardError => e
      fail_upload(upload, e.full_message)
    end

    private

    def fail_upload(upload, fail_reason)
      upload.fail!
      upload.update(fail_reason: fail_reason)
    end
  end
end
