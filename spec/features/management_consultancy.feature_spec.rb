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
    choose I18n.t('journey.choose_lot.answer_lot1')
    click_on I18n.t('common.submit')

    expect(page).to have_text('2 suppliers')
    expect(page).to have_text(/Aardvark Ltd.*Mega Group PLC/)
  end

  scenario 'Buyer wants to buy procurement, supply chain and commercial services (Lot 2)' do
    visit_management_consultancy_home

    click_on 'Start now'
    choose I18n.t('journey.choose_lot.answer_lot2')
    click_on I18n.t('common.submit')

    expect(page).to have_text('2 suppliers')
    expect(page).to have_text(/Mega Group PLC.*Johnson LLP/)
  end

  scenario 'Buyer wants to buy complex & transformation services (Lot 3)' do
    visit_management_consultancy_home

    click_on 'Start now'
    choose I18n.t('journey.choose_lot.answer_lot3')
    click_on I18n.t('common.submit')

    expect(page).to have_text('2 suppliers')
    expect(page).to have_text(/Johnson LLP.*Pi Consulting/)
  end

  scenario 'Buyer wants to buy strategic services (Lot 4)' do
    visit_management_consultancy_home

    click_on 'Start now'
    choose I18n.t('journey.choose_lot.answer_lot4')
    click_on I18n.t('common.submit')

    expect(page).to have_text('2 suppliers')
    expect(page).to have_text(/Aardvark Ltd.*Pi Consulting/)
  end
end
