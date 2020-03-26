module FacilitiesManagement
  class ProcurementInvoiceContactDetail < ProcurementContactDetail
    belongs_to :procurement, class_name: 'FacilitiesManagement::Procurement', foreign_key: :facilities_management_procurement_id, inverse_of: :invoice_contact_detail
  end
end
