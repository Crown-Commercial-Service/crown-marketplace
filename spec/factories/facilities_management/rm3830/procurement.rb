FactoryBot.define do
  factory :facilities_management_rm3830_procurement_no_procurement_buildings, class: 'FacilitiesManagement::RM3830::Procurement' do
    contract_name { Faker::Name.unique.name }
    estimated_cost_known { true }
    estimated_annual_cost { 12345 }
    tupe { false }
    mobilisation_period_required { false }
    extensions_required { false }
    initial_call_off_period_years { 1 }
    initial_call_off_period_months { 0 }
    initial_call_off_start_date { 6.months.from_now }
    service_codes { ['C.1', 'C.2'] }
    user
  end

  factory :facilities_management_rm3830_procurement, parent: :facilities_management_rm3830_procurement_no_procurement_buildings do
    procurement_buildings { build_list(:facilities_management_rm3830_procurement_building, 1) }
  end

  factory :facilities_management_rm3830_procurement_with_extension_periods, parent: :facilities_management_rm3830_procurement do
    mobilisation_period_required { true }
    mobilisation_period { 4 }
    extensions_required { true }
    call_off_extensions do
      build_list(:facilities_management_rm3830_procurement_call_off_extension, 4) do |call_off_extension, index|
        call_off_extension.extension = index
        call_off_extension.years = index
        call_off_extension.months = (index + 1) % 4
      end
    end
  end

  factory :facilities_management_rm3830_procurement_detailed_search, parent: :facilities_management_rm3830_procurement do
    aasm_state { 'detailed_search' }
  end

  factory :facilities_management_rm3830_procurement_without_procurement_buildings, parent: :facilities_management_rm3830_procurement_no_procurement_buildings do
    aasm_state { 'detailed_search' }
    mobilisation_period_required { true }
    mobilisation_period { 4 }
    extensions_required { true }
    call_off_extensions do
      build_list(:facilities_management_rm3830_procurement_call_off_extension, 4) do |call_off_extension, index|
        call_off_extension.extension = index
        call_off_extension.years = index
        call_off_extension.months = (index + 1) % 4
      end
    end
  end

  factory :facilities_management_rm3830_procurement_direct_award, parent: :facilities_management_rm3830_procurement do
    aasm_state { 'da_draft' }
    procurement_suppliers { build_list(:facilities_management_rm3830_procurement_supplier, 3) }
  end

  factory :facilities_management_rm3830_procurement_further_competition, parent: :facilities_management_rm3830_procurement do
    aasm_state { 'further_competition' }
    assessed_value { rand(500..5000) }
  end

  factory :facilities_management_rm3830_procurement_with_contact_details, parent: :facilities_management_rm3830_procurement_with_extension_periods do
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
    procurement_pension_funds { build_list(:facilities_management_rm3830_procurement_pension_fund, 3) }
    invoice_contact_detail { create(:facilities_management_rm3830_procurement_invoice_contact_detail) }
    authorised_contact_detail { create(:facilities_management_rm3830_procurement_authorised_contact_detail) }
    notices_contact_detail { create(:facilities_management_rm3830_procurement_notices_contact_detail) }
    procurement_suppliers { build_list(:facilities_management_rm3830_procurement_supplier, 3) }
    governing_law { 'english' }
  end

  factory :facilities_management_rm3830_procurement_with_contact_details_with_buildings, parent: :facilities_management_rm3830_procurement_with_contact_details do
    tupe { true }
    procurement_buildings { build_list(:facilities_management_rm3830_procurement_building, 2) }
    user factory: %i[user with_detail]
  end

  factory :facilities_management_rm3830_procurement_with_contact_details_with_buildings_no_tupe_london, parent: :facilities_management_rm3830_procurement_with_contact_details do
    tupe { false }
    procurement_buildings { build_list(:facilities_management_rm3830_procurement_building_london, 2) }
  end

  factory :facilities_management_rm3830_procurement_for_further_competition, class: 'FacilitiesManagement::RM3830::Procurement' do
    contract_name { Faker::Name.unique.name }
    estimated_cost_known { false }
    tupe { false }
    initial_call_off_period_years { 1 }
    initial_call_off_period_months { 0 }
    service_codes { ['C.1', 'C.2'] }
    user
    procurement_buildings { build_list(:facilities_management_rm3830_procurement_building_for_further_competition, 1) }
  end

  factory :facilities_management_rm3830_procurement_for_further_competition_with_gia, parent: :facilities_management_rm3830_procurement_for_further_competition do
    initial_call_off_start_date { 6.months.from_now }
    user factory: %i[user with_detail]
    procurement_buildings { build_list(:facilities_management_rm3830_procurement_building_for_further_competition_with_gia, 1) }
  end

  factory :facilities_management_rm3830_procurement_with_security_document, parent: :facilities_management_rm3830_procurement do
    security_policy_document_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test_pdf.pdf'), 'application/pdf') }
  end

  factory :facilities_management_rm3830_procurement_with_lifts, parent: :facilities_management_rm3830_procurement_no_procurement_buildings do
    procurement_buildings { build_list(:facilities_management_rm3830_procurement_building_with_lifts, 1) }
  end

  factory :facilities_management_rm3830_procurement_entering_requirements, class: 'FacilitiesManagement::RM3830::Procurement' do
    contract_name { Faker::Name.unique.name }
    aasm_state { 'detailed_search' }
    user
  end

  factory :facilities_management_rm3830_procurement_entering_requirements_complete, parent: :facilities_management_rm3830_procurement_entering_requirements do
    estimated_cost_known { false }
    tupe { false }
    initial_call_off_period_years { 1 }
    initial_call_off_period_months { 0 }
    initial_call_off_start_date { 6.months.from_now }
    mobilisation_period_required { false }
    extensions_required { false }
    service_codes { ['C.1', 'C.2'] }
  end

  factory :facilities_management_rm3830_procurement_entering_requirements_with_buildings, parent: :facilities_management_rm3830_procurement_entering_requirements do
    procurement_buildings do |procurement|
      build_list(:facilities_management_rm3830_procurement_building, 2) do |procurement_building|
        procurement_building.building.update(user: procurement.user)
      end
    end
  end

  factory :facilities_management_rm3830_procurement_completed_procurement_no_suppliers, parent: :facilities_management_rm3830_procurement_entering_requirements_complete do
    aasm_state { 'direct_award' }
    da_journey_state { 'sent' }
    route_to_market { 'Direct Award' }
    payment_method { 'bacs' }
    using_buyer_detail_for_invoice_details { true }
    using_buyer_detail_for_notices_detail { true }
    using_buyer_detail_for_authorised_detail { true }
    security_policy_document_required { false }
    local_government_pension_scheme { false }
    governing_law { 'english' }
    procurement_buildings { build_list(:facilities_management_rm3830_procurement_building, 2) }
  end
end
