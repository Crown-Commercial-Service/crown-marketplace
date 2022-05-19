FactoryBot.define do
  factory :facilities_management_rm6232_procurement_no_procurement_buildings, class: 'FacilitiesManagement::RM6232::Procurement' do
    service_codes { ['E.1', 'E.2'] }
    region_codes { ['UKI4', 'UKI5'] }
    annual_contract_value { 12345 }
    contract_name { Faker::Name.unique.name }
    lot_number { '2a' }
    association :user
  end
end
