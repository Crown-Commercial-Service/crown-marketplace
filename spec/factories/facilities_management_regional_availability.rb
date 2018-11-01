FactoryBot.define do
  factory :facilities_management_regional_availability do
    association :supplier, factory: :facilities_management_supplier
    lot_number { FacilitiesManagementRegionalAvailability::LOT_NUMBERS.keys.sample }
    region_code { 'UKC1' }
  end
end
