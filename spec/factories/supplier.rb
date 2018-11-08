FactoryBot.define do
  factory :supplier, class: SupplyTeachers::Supplier do
    name { Faker::Company.unique.name }
  end
end
