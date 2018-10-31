FactoryBot.define do
  factory :facilities_management_supplier do
    name { Faker::Company.unique.name }
  end
end
