FactoryBot.define do
  factory :supplier, class: 'Supplier' do
    name { Faker::Name.unique.name }
    duns_number { Faker::Company.unique.duns_number }
    sme { rand > 0.5 }

    trait :with_supplier_frameworks do
      supplier_frameworks { create_list(:supplier_framework, 2) }
    end
  end
end
