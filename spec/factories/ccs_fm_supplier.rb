FactoryBot.define do
  factory :ccs_fm_supplier, class: CCS::FM::Supplier do
    id { SecureRandom.uuid }
    data do
      {
        supplier_id: id,
        supplier_name: Faker::Company.unique.name
      }
    end
  end
end
