FactoryBot.define do
  factory :supplier_framework_contact_detail, class: 'Supplier::Framework::ContactDetail' do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    telephone_number { Faker::PhoneNumber.unique.phone_number }
    website { Faker::Internet.unique.url }

    after(:build) do |supplier_framework_contact_detail, evaluator|
      supplier_framework_contact_detail.supplier_framework ||= evaluator.supplier_framework || create(:supplier_framework)
    end
  end
end
