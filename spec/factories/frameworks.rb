FactoryBot.define do
  factory :framework, class: 'Framework' do
    id { "FK#{Faker::Number.unique.leading_zero_number(digits: 4)}" }
    service { ('a'..'z').to_a.sample(8).join }
    live_at { 1.year.from_now }
    expires_at { 2.years.from_now }
  end
end
