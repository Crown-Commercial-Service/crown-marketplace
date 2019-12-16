FactoryBot.define do
  factory :facilities_management_procurement, class: FacilitiesManagement::Procurement do
    name { Faker::Name.unique.name }
    contract_name { 'Contract name' }
    estimated_cost_known { 12345 }
    tupe { false }
    initial_call_off_period { Time.zone.now + 6.months }
    service_codes { ['C.1', 'C.2'] }
    association :user
    procurement_buildings { build_list :facilities_management_procurement_building, 1 }
  end
end
