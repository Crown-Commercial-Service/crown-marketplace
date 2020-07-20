require 'json'

namespace :supplier_emails do
  desc 'update supplier emails'
  task update: :environment do
    p 'updating emails'

    replacement_email_array = JSON.parse ENV['REPLACEMENT_EMAILS']

    return 'nothing to update' if replacement_email_array.nil?

    service = FacilitiesManagement::SupplierEmailReplacement.new(replacement_email_array)

    service.replace
  end
end
