FactoryBot.define do
  factory :facilities_management_rm6378_procurement_base, parent: :procurement, class: 'FacilitiesManagement::RM6378::Procurement' do
    framework_id { 'RM6378' }
    lot_id { 'RM6378.1a' }
    contract_name { Faker::Name.unique.name }

    procurement_details do
      {
        'service_ids' => ['RM6378.1a.E1', 'RM6378.1a.E2'],
        'jurisdiction_ids' => ['TLH3', 'TLH5'],
        'annual_contract_value' => 12_345,
        'requirements_linked_to_pfi' => true
      }
    end
  end

  factory :facilities_management_rm6378_procurement, parent: :facilities_management_rm6378_procurement_base do
    contract_number { 'RM6378-000001-2022' }

    before(:create) do
      FacilitiesManagement::RM6378::Procurement.skip_callback(:create, :before, :generate_contract_number)
    end

    after(:create) do
      FacilitiesManagement::RM6378::Procurement.set_callback(:create, :before, :generate_contract_number)
    end
  end
end
