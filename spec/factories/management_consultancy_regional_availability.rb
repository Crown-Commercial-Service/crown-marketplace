FactoryBot.define do
  factory :management_consultancy_regional_availability, class: ManagementConsultancy::RegionalAvailability do
    association :supplier, factory: :management_consultancy_supplier
    lot_number { 'MCF2.1' }
    region_code { 'UKC1' }
    expenses_required { false }
  end
end
