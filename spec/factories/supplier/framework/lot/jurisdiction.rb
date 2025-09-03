FactoryBot.define do
  factory :supplier_framework_lot_jurisdiction, class: 'Supplier::Framework::Lot::Jurisdiction' do
    after(:build) do |supplier_framework_lot_jurisdiction, evaluator|
      supplier_framework_lot_jurisdiction.supplier_framework_lot ||= evaluator.supplier_framework_lot || create(:supplier_framework_lot)
      supplier_framework_lot_jurisdiction.jurisdiction ||= evaluator.jurisdiction || create(:jurisdiction)
    end
  end
end
