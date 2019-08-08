FactoryBot.define do
  factory :legal_services_supplier, class: LegalServices::Supplier do
    name { Faker::Company.unique.name }
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.unique.phone_number }
  end
end
