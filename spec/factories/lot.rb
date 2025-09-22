FactoryBot.define do
  factory :lot, class: 'Lot' do
    number { Faker::Number.number(digits: 2) }
    name { Faker::Alphanumeric.alphanumeric(number: 10) }

    after(:build) do |lot, evaluator|
      lot.framework ||= evaluator.framework || create(:framework)
      lot.id = "#{lot.framework.id}.#{lot.number}"
    end
  end
end
