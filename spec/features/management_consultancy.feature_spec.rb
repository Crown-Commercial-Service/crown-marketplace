require 'rails_helper'

RSpec.feature 'Management consultancy', type: :feature do
  scenario 'Buyer wants to buy management consultancy services' do
    visit_management_consultancy_home

    ccs_host = 'https://ccs-agreements.cabinetoffice.gov.uk'
    lot1_suppliers_path = '/suppliers?sm_field_contract_id=RM6008*'
    lot1_suppliers_url = "#{ccs_host}#{lot1_suppliers_path}"

    expect(page).to have_link('Start now', href: lot1_suppliers_url)
  end
end
