FactoryBot.define do
  factory :supplier_framework_lot, class: 'Supplier::Framework::Lot' do
    enabled { true }

    after(:build) do |supplier_framework_lot, evaluator|
      supplier_framework_lot.supplier_framework ||= evaluator.supplier_framework || create(:supplier_framework)
      supplier_framework_lot.lot ||= evaluator.lot || create(:lot)
    end

    trait :with_rates do
      after(:create) do |supplier_framework_lot|
        create(:supplier_framework_lot_rate, position_id: "#{supplier_framework_lot.lot_id}.10", rate: 1050, supplier_framework_lot: supplier_framework_lot)
        create(:supplier_framework_lot_rate, position_id: "#{supplier_framework_lot.lot_id}.1", rate: 2050, supplier_framework_lot: supplier_framework_lot)
        create(:supplier_framework_lot_rate, position_id: "#{supplier_framework_lot.lot_id}.11", rate: 3050, supplier_framework_lot: supplier_framework_lot)
      end
    end

    trait :with_extra_rates do
      after(:create) do |supplier_framework_lot|
        create(:supplier_framework_lot_rate, position_id: "#{supplier_framework_lot.lot_id}.5", rate: 4050, supplier_framework_lot: supplier_framework_lot)
      end
    end
  end
end
