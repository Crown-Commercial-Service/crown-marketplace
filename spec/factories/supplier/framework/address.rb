FactoryBot.define do
  factory :supplier_framework_address, class: 'Supplier::Framework::Address' do
    address_line_1 { Faker::Address.unique.street_name }
    address_line_2 { Faker::Address.unique.secondary_address }
    town { Faker::Address.unique.city }
    county { Faker::Address.unique.county }
    postcode { Faker::Address.unique.postcode }

    after(:build) do |supplier_framework_address, evaluator|
      supplier_framework_address.supplier_framework ||= evaluator.supplier_framework || create(:supplier_framework)
    end
  end
end
