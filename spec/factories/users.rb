FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    first_name { Faker::Name.name }
    confirmed_at { Time.zone.now }

    trait :with_detail do
      buyer_detail { build(:buyer_detail) }
    end

    trait :without_detail do
      buyer_detail { nil }
    end

    trait :with_phone_number do
      phone_number { Faker::PhoneNumber.unique.cell_phone }
    end
  end
end
