FactoryBot.define do
  factory :supplier_framework_lot_service, class: 'Supplier::Framework::Lot::Service' do
    after(:build) do |supplier_framework_lot_service, evaluator|
      supplier_framework_lot_service.supplier_framework_lot ||= evaluator.supplier_framework_lot || create(:supplier_framework_lot)
      supplier_framework_lot_service.service ||= evaluator.service || create(:service)
    end
  end
end
