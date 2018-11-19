FactoryBot.define do
  factory :management_consultancy_regional_availability, class: ManagementConsultancy::RegionalAvailability do
    association :supplier, factory: :management_consultancy_supplier
    lot_number { ManagementConsultancy::Lot.all.map(&:number).sample }
    region_code { 'UKC1' }
  end
end
