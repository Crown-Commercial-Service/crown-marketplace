class ChangeLog < ApplicationRecord
  include Loggable

  belongs_to :framework, inverse_of: :change_logs
  belongs_to :user, inverse_of: :change_logs

  CHANGE_TYPES = {
    upload_supplier_data: 'upload_supplier_data',
    update_supplier_information: 'update_supplier_information',
    update_supplier_contact_information: 'update_supplier_contact_information',
    update_supplier_additional_information: 'update_supplier_additional_information',
    update_supplier_framework_lot_status: 'update_supplier_framework_lot_status',
    update_supplier_framework_lot_services: 'update_supplier_framework_lot_services',
    update_supplier_framework_lot_jurisdictions: 'update_supplier_framework_lot_jurisdictions',
    update_supplier_framework_lot_rates: 'update_supplier_framework_lot_rates',
    update_supplier_framework_lot_branch: 'update_supplier_framework_lot_branch',
    add_rates_for_supplier_framework_lot_jurisdiction: 'add_rates_for_supplier_framework_lot_jurisdiction',
    remove_rates_for_supplier_framework_lot_jurisdiction: 'remove_rates_for_supplier_framework_lot_jurisdiction'
  }.freeze

  validates :change_type, inclusion: { in: CHANGE_TYPES.values }

  def short_id
    "##{id[..7]}"
  end

  def changed_by
    user.email
  end
end
