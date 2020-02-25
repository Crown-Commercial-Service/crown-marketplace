FactoryBot.define do
  factory :facilities_management_procurement, class: FacilitiesManagement::Procurement do
    name { Faker::Name.unique.name }
    contract_name { 'Contract name' }
    estimated_cost_known { 12345 }
    tupe { false }
    initial_call_off_period { 1 }
    service_codes { ['C.1', 'C.2'] }
    association :user
    procurement_buildings { build_list :facilities_management_procurement_building, 1 }
  end

  factory :facilities_management_procurement_with_extension_periods, parent: :facilities_management_procurement do
    initial_call_off_start_date { Time.zone.now + 6.months }
    mobilisation_period_required { true }
    mobilisation_period { 4 }
    extensions_required { true }
    optional_call_off_extensions_1 { 1 }
    optional_call_off_extensions_2 { 1 }
    optional_call_off_extensions_3 { 1 }
    optional_call_off_extensions_4 { 1 }
  end

  factory :facilities_management_procurement_direct_award, parent: :facilities_management_procurement do
    aasm_state { 'da_draft' }
  end

  factory :facilities_management_procurement_further_competition, parent: :facilities_management_procurement do
    aasm_state { 'further_competition' }
  end

  factory :facilities_management_procurement_no_procurement_buildings, parent: :facilities_management_procurement do
    procurement_buildings { [] }
  end

end
