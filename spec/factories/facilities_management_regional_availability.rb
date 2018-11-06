FactoryBot.define do
  factory :facilities_management_regional_availability, class: FacilitiesManagement::RegionalAvailability do
    association :supplier, factory: :facilities_management_supplier
    lot_number { FacilitiesManagement::Lot.all.map(&:number).sample }
    region_code { 'UKC1' }
  end
end
