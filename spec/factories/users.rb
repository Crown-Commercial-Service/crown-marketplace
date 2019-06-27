FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    first_name { Faker::Name.name }
    confirmed_at { Time.zone.now }
  end
end
