require 'rake'
require 'aws-sdk-s3'
require './lib/tasks/legal_services/scripts/add_suppliers'
require './lib/tasks/legal_services/scripts/add_lot_1_services_per_supplier'
require './lib/tasks/legal_services/scripts/add_lot_2_services_per_supplier'
require './lib/tasks/legal_services/scripts/add_lot_3_and_4_services_per_supplier'
require './lib/tasks/legal_services/scripts/add_rate_cards_to_suppliers'

class LegalServices::DataTransformationService
  def initialize(upload_id)
    @upload = LegalServices::Admin::Upload.find(upload_id)
  end

  def run
    add_suppliers(@upload.id)
    add_lot_1_services_per_supplier(@upload.id)
    add_lot_2_services_per_supplier(@upload.id)
    add_lot_3_and_4_services_per_supplier(@upload.id)
    add_rate_cards_to_suppliers(@upload.id)

    @upload.review!
  rescue StandardError => e
    fail_upload(e.full_message)
  end

  private

  def fail_upload(fail_reason)
    @upload.fail!
    @upload.update(fail_reason: fail_reason)
  end
end
