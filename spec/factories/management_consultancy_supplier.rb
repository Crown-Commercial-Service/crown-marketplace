FactoryBot.define do
  factory :management_consultancy_supplier, class: ManagementConsultancy::Supplier do
    name { Faker::Company.unique.name }
  end
end
