FactoryBot.define do
  factory :facilities_management_service_offering, class: FacilitiesManagement::ServiceOffering do
    association :supplier, factory: :facilities_management_supplier
    lot_number { '1a' }
    service_code { 'A.7' }
  end
end
