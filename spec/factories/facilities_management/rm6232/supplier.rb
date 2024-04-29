FactoryBot.define do
  factory :facilities_management_rm6232_supplier, class: 'FacilitiesManagement::RM6232::Supplier' do
    supplier_name { "CCS #{Faker::Company.unique.name}" }
    sme { true }
    duns { Faker::Company.unique.duns_number.gsub('-', '') }
    registration_number { '0123456' }
    address_line_1 { Faker::Address.street_address }
    address_line_2 { Faker::Address.street_name }
    address_town { Faker::Address.city }
    address_county { Faker::Address.county }
    address_postcode { Faker::Address.postcode }
    lot_data { build_list(:facilities_management_rm6232_supplier_lot_data, 1) }
  end
end
