FactoryBot.define do
  factory :user do
    trait :with_detail do
      email { Faker::Internet.unique.email }
      first_name { Faker::Name.name }
      confirmed_at { Time.zone.now }
      buyer_detail { build :buyer_detail }
    end

    trait :without_detail do
      email { Faker::Internet.unique.email }
      first_name { Faker::Name.name }
      confirmed_at { Time.zone.now }
      buyer_detail { nil }
    end
  end
end
