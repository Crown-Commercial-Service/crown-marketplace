FactoryBot.define do
  factory :supply_teachers_supplier, class: SupplyTeachers::Supplier do
    name { Faker::Company.unique.name }
  end
end
