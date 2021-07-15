module FacilitiesManagement
  module RM3830
    class ProcurementInvoiceContactDetail < ProcurementContactDetail
      belongs_to :procurement, class_name: 'FacilitiesManagement::RM3830::Procurement', foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :invoice_contact_detail
    end
  end
end
