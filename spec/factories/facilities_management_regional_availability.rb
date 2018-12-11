FactoryBot.define do
  factory :facilities_management_regional_availability, class: FacilitiesManagement::RegionalAvailability do
    association :supplier, factory: :facilities_management_supplier
    lot_number { '1a' }
    region_code { 'UKC1' }
  end
end
