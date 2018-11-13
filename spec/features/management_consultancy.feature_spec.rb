require 'rails_helper'

RSpec.feature 'Management consultancy', type: :feature do
  before do
    supplier1 = create(:management_consultancy_supplier, name: 'Aardvark Ltd')
    supplier2 = create(:management_consultancy_supplier, name: 'Mega Group PLC')
    supplier3 = create(:management_consultancy_supplier, name: 'Johnson LLP')
    supplier4 = create(:management_consultancy_supplier, name: 'Pi Consulting')

    supplier1.service_offerings.create!(lot_number: '1', service_code: '1.1')
    supplier1.service_offerings.create!(lot_number: '1', service_code: '1.2')
    supplier2.service_offerings.create!(lot_number: '1', service_code: '1.3')

    supplier2.service_offerings.create!(lot_number: '2', service_code: '2.1')
    supplier3.service_offerings.create!(lot_number: '2', service_code: '2.2')
    supplier3.service_offerings.create!(lot_number: '2', service_code: '2.3')

    supplier3.service_offerings.create!(lot_number: '3', service_code: '3.1')
    supplier4.service_offerings.create!(lot_number: '3', service_code: '3.2')

    supplier1.service_offerings.create!(lot_number: '4', service_code: '4.1')
    supplier4.service_offerings.create!(lot_number: '4', service_code: '4.2')
  end

  scenario 'Buyer wants to buy business services (Lot 1)' do
    visit_management_consultancy_home

    click_on 'Start now'
    choose 'Lot 1 - business services'
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Lot 1 - business services')
    expect(page).to have_text('2 suppliers')
    expect(page).to have_text(/Aardvark Ltd.*\n.*Mega Group PLC/)
  end

  scenario 'Buyer wants to buy procurement, supply chain and commercial services (Lot 2)' do
    visit_management_consultancy_home

    click_on 'Start now'
    choose 'Lot 2 - procurement, supply chain and commercial services'
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Lot 2 - procurement, supply chain and commercial services')
    expect(page).to have_text('2 suppliers')
    expect(page).to have_text(/Mega Group PLC.*\n.*Johnson LLP/)
  end

  scenario 'Buyer wants to buy complex & transformation services (Lot 3)' do
    visit_management_consultancy_home

    click_on 'Start now'
    choose 'Lot 3 - complex and transformation services'
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Lot 3 - complex and transformation services')
    expect(page).to have_text('2 suppliers')
    expect(page).to have_text(/Johnson LLP.*\n.*Pi Consulting/)
  end

  scenario 'Buyer wants to buy strategic services (Lot 4)' do
    visit_management_consultancy_home

    click_on 'Start now'
    choose 'Lot 4 - strategic services'
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Lot 4 - strategic services')
    expect(page).to have_text('2 suppliers')
    expect(page).to have_text(/Aardvark Ltd.*\n.*Pi Consulting/)
  end
end
