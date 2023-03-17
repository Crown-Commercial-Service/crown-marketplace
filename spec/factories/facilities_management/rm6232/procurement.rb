FactoryBot.define do
  factory :facilities_management_rm6232_procurement_no_contract_number, class: 'FacilitiesManagement::RM6232::Procurement' do
    service_codes { ['E.1', 'E.2'] }
    region_codes { ['UKI4', 'UKI5'] }
    annual_contract_value { 12_345 }
    contract_name { Faker::Name.unique.name }
    association :user

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

  factory :facilities_management_rm6232_procurement, parent: :facilities_management_rm6232_procurement_no_contract_number, traits: [:skip_before_create] do
    lot_number { '2a' }
    contract_number { 'RM6232-000001-2022' }
  end
end
