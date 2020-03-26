FactoryBot.define do
  factory :facilities_management_procurement_authorised_contact_detail, parent: :facilities_management_procurement_contact_detail, class: FacilitiesManagement::ProcurementAuthorisedContactDetail do
    telephone_number { '07500404040' }
    association :procurement, factory: :facilities_management_procurement
  end
end
