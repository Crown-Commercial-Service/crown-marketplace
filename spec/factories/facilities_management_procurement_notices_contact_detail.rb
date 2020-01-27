FactoryBot.define do
  factory :facilities_management_procurement_notices_contact_detail, parent: :facilities_management_procurement_contact_detail, class: FacilitiesManagement::ProcurementNoticesContactDetail do
    association :procurement, factory: :facilities_management_procurement
  end
end
