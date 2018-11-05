FactoryBot.define do
  factory :facilities_management_regional_availability do
    association :supplier, factory: :facilities_management_supplier
    lot_number { FacilitiesManagementLot.all.map(&:number).sample }
    region_code { 'UKC1' }
  end
end
