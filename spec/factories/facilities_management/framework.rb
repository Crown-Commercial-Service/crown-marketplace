FactoryBot.define do
  factory :facilities_management_framework, class: 'FacilitiesManagement::Framework' do
    id { SecureRandom.uuid }
    framework { "FK#{Array.new(4) { rand(10) }.join}" }
    live_at { 1.year.from_now }
  end
end
