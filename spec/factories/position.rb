FactoryBot.define do
  factory :position, class: 'Position' do
    initialize_with { Position.find(Faker::Number.unique.between(from: 1, to: 50)) }
  end
end
