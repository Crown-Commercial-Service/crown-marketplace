FactoryBot.define do
  factory :supplier_framework_lot_rate, class: 'Supplier::Framework::Lot::Rate' do
    rate { Faker::Number.within(range: 10000..100000000) }

    after(:build) do |supplier_framework_lot_service, evaluator|
      supplier_framework_lot_service.supplier_framework_lot ||= evaluator.supplier_framework_lot || create(:supplier_framework_lot)
      supplier_framework_lot_service.position ||= evaluator.position || create(:position)
      supplier_framework_lot_service.jurisdiction ||= evaluator.jurisdiction || create(:supplier_framework_lot_jurisdiction, supplier_framework_lot: supplier_framework_lot_service.supplier_framework_lot)
    end
  end
end
