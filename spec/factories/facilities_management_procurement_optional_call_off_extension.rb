FactoryBot.define do
  factory :facilities_management_procurement_optional_call_off_extension, class: FacilitiesManagement::Procurement::OptionalCallOffExtension do
    extension { 0 }
    years { 1 }
    months { 1 }
    extension_required { 'true' }
    association :procurement, factory: :facilities_management_procurement
  end
end
