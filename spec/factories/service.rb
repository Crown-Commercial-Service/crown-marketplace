FactoryBot.define do
  factory :service, class: 'Service' do
    number { Faker::Number.number(digits: 2) }
    name { Faker::Alphanumeric.alphanumeric(number: 10) }

    after(:build) do |service, evaluator|
      service.lot ||= evaluator.lot || create(:lot)
      service.id = "#{service.lot.id}.#{service.number}"
    end
  end
end
