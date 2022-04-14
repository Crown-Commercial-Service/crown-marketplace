FactoryBot.define do
  factory :facilities_management_framework, class: 'FacilitiesManagement::Framework' do
    id { SecureRandom.uuid }
    framework { "FK#{Array.new(4) { rand(10) }.join}" }
    live_at { Time.zone.now + 1.year }
  end
end
