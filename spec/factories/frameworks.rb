FactoryBot.define do
  factory :framework, class: 'Framework' do
    id { SecureRandom.uuid }
    service { ('a'..'z').to_a.sample(8).join }
    framework { "FK#{Array.new(4) { rand(10) }.join}" }
    live_at { 1.year.from_now }
    expires_at { 2.years.from_now }
  end
end
