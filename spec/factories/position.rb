FactoryBot.define do
  factory :position, class: 'Position' do
    number { Faker::Number.number(digits: 3) }
    name { Faker::Alphanumeric.alphanumeric(number: 10) }

    after(:build) do |position, evaluator|
      position.lot ||= evaluator.lot || create(:lot)
      position.id = "#{position.lot.id}.#{position.number}"
    end
  end
end
