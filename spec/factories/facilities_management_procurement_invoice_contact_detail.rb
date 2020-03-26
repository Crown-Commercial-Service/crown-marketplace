FactoryBot.define do
  factory :facilities_management_procurement_invoice_contact_detail, parent: :facilities_management_procurement_contact_detail, class: FacilitiesManagement::ProcurementInvoiceContactDetail do
    association :procurement, factory: :facilities_management_procurement
  end
end
