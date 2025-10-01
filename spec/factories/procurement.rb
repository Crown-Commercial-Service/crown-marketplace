FactoryBot.define do
  factory :procurement, class: 'Procurement' do
    contract_name { Faker::Name.unique.name }

    user { association(:user) }

    after(:build) do |procurement, evaluator|
      procurement.framework ||= evaluator.framework || create(:framework)
      procurement.lot ||= evaluator.lot || create(:lot)
    end
  end
end
