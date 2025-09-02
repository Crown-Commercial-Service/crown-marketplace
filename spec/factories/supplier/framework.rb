FactoryBot.define do
  factory :supplier_framework, class: 'Supplier::Framework' do
    enabled { true }

    after(:build) do |supplier_framework, evaluator|
      supplier_framework.supplier ||= evaluator.supplier || create(:supplier)
      supplier_framework.framework ||= evaluator.framework || create(:framework)
    end
  end
end
