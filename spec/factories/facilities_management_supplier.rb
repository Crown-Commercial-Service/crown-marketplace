FactoryBot.define do
  factory :facilities_management_supplier, class: FacilitiesManagement::Supplier do
    name { Faker::Company.unique.name }
    contact_name { Faker::Name.unique.name }
    contact_email { Faker::Internet.unique.email }
    telephone_number { Faker::PhoneNumber.unique.phone_number }
  end
end
