FactoryBot.define do
  factory :supplier do
    name { Faker::Company.unique.name }
  end
end
