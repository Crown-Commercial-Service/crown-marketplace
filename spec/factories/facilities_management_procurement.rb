FactoryBot.define do
  factory :facilities_management_procurement, class: FacilitiesManagement::Procurement do
    contract_name { Faker::Name.unique.name }
    estimated_cost_known { 12345 }
    tupe { false }
    initial_call_off_period { 1 }
    service_codes { ['C.1', 'C.2'] }
    association :user
    procurement_buildings { build_list :facilities_management_procurement_building, 1 }
  end

  factory :facilities_management_procurement_with_extension_periods, parent: :facilities_management_procurement do
    initial_call_off_start_date { Time.zone.now + 6.months }
    mobilisation_period_required { true }
    mobilisation_period { 4 }
    extensions_required { true }
    optional_call_off_extensions_1 { 1 }
    optional_call_off_extensions_2 { 1 }
    optional_call_off_extensions_3 { 1 }
    optional_call_off_extensions_4 { 1 }
  end

  factory :facilities_management_procurement_detailed_search, parent: :facilities_management_procurement do
    aasm_state { 'detailed_search' }
  end

  factory :facilities_management_procurement_direct_award, parent: :facilities_management_procurement do
    aasm_state { 'da_draft' }
    procurement_suppliers { build_list :facilities_management_procurement_supplier, 3 }
  end

  factory :facilities_management_procurement_further_competition, parent: :facilities_management_procurement do
    aasm_state { 'further_competition' }
  end

  factory :facilities_management_procurement_no_procurement_buildings, parent: :facilities_management_procurement do
    procurement_buildings { [] }
  end

  factory :facilities_management_procurement_with_contact_details, parent: :facilities_management_procurement_with_extension_periods do
    aasm_state { 'direct_award' }
    security_policy_document_required { false }
    security_policy_document_name { Faker::Name.name }
    security_policy_document_version_number { 1 }
    security_policy_document_date { DateTime.now.in_time_zone('London') }
    lot_number { '1a' }
    assessed_value { rand(500..5000) }
    eligible_for_da { true }
    da_journey_state { 'sent' }
    payment_method { 'bacs' }
    route_to_market { 'Direct Award' }
    using_buyer_detail_for_invoice_details { true }
    using_buyer_detail_for_notices_detail { false }
    using_buyer_detail_for_authorised_detail { false }
    local_government_pension_scheme { true }
    procurement_pension_funds { build_list :facilities_management_procurement_pension_fund, 3 }
    invoice_contact_detail { create :facilities_management_procurement_invoice_contact_detail }
    authorised_contact_detail { create :facilities_management_procurement_authorised_contact_detail }
    notices_contact_detail { create :facilities_management_procurement_notices_contact_detail }
    procurement_suppliers { build_list :facilities_management_procurement_supplier, 3 }
  end
end
