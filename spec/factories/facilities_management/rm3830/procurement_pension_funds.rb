FactoryBot.define do
  factory :facilities_management_rm3830_procurement_pension_fund, class: 'FacilitiesManagement::RM3830::ProcurementPensionFund' do
    name { Faker::Name.unique.name[1..150] }
    percentage { rand(1..100).to_s }
    procurement factory: %i[facilities_management_rm3830_procurement]
  end
end
