require 'rails_helper'

def mc_lot_link(lot:)
  ccs_host = 'https://ccs-agreements.cabinetoffice.gov.uk'
  suppliers_path = "/suppliers?sm_field_contract_id=\"RM6008%3A#{lot}\""
  "#{ccs_host}#{suppliers_path}"
end

RSpec.feature 'Management consultancy', type: :feature do
  scenario 'Buyer wants to buy management consultancy services' do
    visit_management_consultancy_home

    click_on 'Start now'
    choose 'Lot 1 - business services'
    click_on I18n.t('common.submit')
    expect(page).to have_link('View a list of suppliers', href: mc_lot_link(lot: 1))

    click_on 'Back'
    choose 'Lot 2 - procurement, supply chain and commercial services'
    click_on I18n.t('common.submit')

    expect(page).to have_link('View a list of suppliers', href: mc_lot_link(lot: 2))

    click_on 'Back'
    choose 'Lot 3 - complex and transformation services'
    click_on I18n.t('common.submit')

    expect(page).to have_link('View a list of suppliers', href: mc_lot_link(lot: 3))

    click_on 'Back'
    choose 'Lot 4 - strategic services'
    click_on I18n.t('common.submit')

    expect(page).to have_link('View a list of suppliers', href: mc_lot_link(lot: 4))
  end
end
