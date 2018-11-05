FactoryBot.define do
  factory :facilities_management_service_offering do
    association :supplier, factory: :facilities_management_supplier
    lot_number { FacilitiesManagementRegionalAvailability::LOT_NUMBERS.keys.sample }
    service_code { 'A.7' }
  end
end
