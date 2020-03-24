FactoryBot.define do
  factory :facilities_management_procurement_pension_fund, class: FacilitiesManagement::ProcurementPensionFund do
    name { Faker::Name.unique.name[1..150] }
    percentage { rand(1..100).to_s }
  end
end
