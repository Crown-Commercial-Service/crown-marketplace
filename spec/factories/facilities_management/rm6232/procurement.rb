FactoryBot.define do
  factory :facilities_management_rm6232_procurement_no_procurement_buildings, class: 'FacilitiesManagement::RM6232::Procurement' do
    service_codes { ['E.1', 'E.2'] }
    region_codes { ['UKI4', 'UKI5'] }
    annual_contract_value { 12_345 }
    contract_name { Faker::Name.unique.name }
    requirements_linked_to_pfi { true }
    user

    trait :skip_generate_contract_number do
      before(:create) { |procurement| procurement.class.skip_callback(:create, :before, :generate_contract_number, raise: false) }

      after(:create) { |procurement| procurement.class.set_callback(:create, :before, :generate_contract_number) }
    end

    trait :skip_determine_lot_number do
      before(:create) { |procurement| procurement.class.skip_callback(:create, :before, :determine_lot_number, raise: false) }

      after(:create) { |procurement| procurement.class.set_callback(:create, :before, :determine_lot_number) }
    end

    trait :skip_before_create do
      before(:create) do |procurement|
        procurement.class.skip_callback(:create, :before, :generate_contract_number, raise: false)
        procurement.class.skip_callback(:create, :before, :determine_lot_number, raise: false)
      end

      after(:create) do |procurement|
        procurement.class.set_callback(:create, :before, :generate_contract_number)
        procurement.class.set_callback(:create, :before, :determine_lot_number)
      end
    end
  end

  factory :facilities_management_rm6232_procurement_what_happens_next, parent: :facilities_management_rm6232_procurement_no_procurement_buildings, traits: [:skip_before_create] do
    aasm_state { 'what_happens_next' }
    lot_number { '2a' }
    contract_number { 'RM6232-000001-2022' }
  end

  factory :facilities_management_rm6232_procurement_entering_requirements, parent: :facilities_management_rm6232_procurement_what_happens_next do
    aasm_state { 'entering_requirements' }
    tupe { false }
    initial_call_off_period_years { 1 }
    initial_call_off_period_months { 0 }
    initial_call_off_start_date { 6.months.from_now }
    mobilisation_period_required { false }
    extensions_required { false }
  end

  factory :facilities_management_rm6232_procurement_entering_requirements_empty, parent: :facilities_management_rm6232_procurement_what_happens_next do
    aasm_state { 'entering_requirements' }
  end

  factory :facilities_management_rm6232_procurement_with_extension_periods, parent: :facilities_management_rm6232_procurement_entering_requirements do
    mobilisation_period_required { true }
    mobilisation_period { 4 }
    extensions_required { true }
    call_off_extensions do
      build_list(:facilities_management_rm6232_procurement_call_off_extension, 4) do |call_off_extension, index|
        call_off_extension.extension = index
        call_off_extension.years = index
        call_off_extension.months = (index + 1) % 4
      end
    end
  end

  factory :facilities_management_rm6232_procurement_entering_requirements_with_buildings, parent: :facilities_management_rm6232_procurement_entering_requirements do
    procurement_buildings do |procurement|
      build_list(:facilities_management_rm6232_procurement_building, 2) do |procurement_building|
        procurement_building.building.update(user: procurement.user)
      end
    end
  end

  factory :facilities_management_rm6232_procurement_results, parent: :facilities_management_rm6232_procurement_entering_requirements do
    aasm_state { 'results' }

    procurement_buildings do |procurement|
      build_list(:facilities_management_rm6232_procurement_building_with_frozen_data, 2) do |procurement_building|
        procurement_building.building.update(user: procurement.user)
      end
    end
  end

  factory :facilities_management_rm6232_procurement_further_information, parent: :facilities_management_rm6232_procurement_results do
    aasm_state { 'further_information' }
  end
end
