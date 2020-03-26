FactoryBot.define do
  factory :supply_teachers_supplier, class: SupplyTeachers::Supplier do
    name { Faker::Name.unique.name }
  end
end
