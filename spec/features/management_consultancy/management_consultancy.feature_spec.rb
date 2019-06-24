require 'rails_helper'

RSpec.feature 'Management consultancy', type: :feature do
  before do
    supplier1 = create(:management_consultancy_supplier, name: 'Aardvark Ltd')
    supplier2 = create(:management_consultancy_supplier, name: 'Mega Group PLC')
    supplier3 = create(:management_consultancy_supplier, name: 'Johnson LLP')
    supplier4 = create(:management_consultancy_supplier, name: 'Pi Consulting')
    supplier5 = create(:management_consultancy_supplier, name: 'Nowhere Consulting')

    supplier1.service_offerings.create!(lot_number: 'MCF2.1', service_code: 'MCF2.1.1')
    supplier1.service_offerings.create!(lot_number: 'MCF2.1', service_code: 'MCF2.1.2')
    supplier1.service_offerings.create!(lot_number: 'MCF2.4', service_code: 'MCF2.4.10')

    supplier2.service_offerings.create!(lot_number: 'MCF2.1', service_code: 'MCF2.1.3')
    supplier2.service_offerings.create!(lot_number: 'MCF2.2', service_code: 'MCF2.2.1')

    supplier3.service_offerings.create!(lot_number: 'MCF2.2', service_code: 'MCF2.2.2')
    supplier3.service_offerings.create!(lot_number: 'MCF2.2', service_code: 'MCF2.2.3')
    supplier3.service_offerings.create!(lot_number: 'MCF2.3', service_code: 'MCF2.3.10')

    supplier4.service_offerings.create!(lot_number: 'MCF2.3', service_code: 'MCF2.3.2')
    supplier4.service_offerings.create!(lot_number: 'MCF2.4', service_code: 'MCF2.4.2')

    supplier5.service_offerings.create!(lot_number: 'MCF2.1', service_code: 'MCF2.1.1')
    supplier5.service_offerings.create!(lot_number: 'MCF2.1', service_code: 'MCF2.1.2')
    supplier5.service_offerings.create!(lot_number: 'MCF2.1', service_code: 'MCF2.1.3')

    supplier1.regional_availabilities.create!(
      lot_number: 'MCF2.1', region_code: 'UKC1', expenses_required: true
    )
    supplier2.regional_availabilities.create!(
      lot_number: 'MCF2.2', region_code: 'UKC2', expenses_required: false
    )
    supplier3.regional_availabilities.create!(
      lot_number: 'MCF2.3', region_code: 'UKD1', expenses_required: false
    )
    supplier1.regional_availabilities.create!(
      lot_number: 'MCF2.4', region_code: 'UKD3', expenses_required: false
    )
  end

  scenario 'Buyer wants to buy business consultancy services (MCF2 Lot 1)' do
    visit_management_consultancy_start

    required_service = ManagementConsultancy::Service.where(code: 'MCF2.1.1').first
    required_region = Nuts2Region.find_by(code: 'UKC1')

    choose 'help_needed_management_consultants'
    click_on 'Continue'

    choose 'Lot MCF2.1 - Business Consultancy Services'
    click_on I18n.t('common.submit')

    check required_service.name
    click_on I18n.t('common.submit')

    check required_region.name
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Supplier results')
    expect(page).to have_text('1 company')
    expect(page).to have_text(/Aardvark Ltd/)
  end

  scenario 'Buyer wants to buy procurement, supply chain and commercial services (MCF2 Lot 2)' do
    visit_management_consultancy_start

    required_service = ManagementConsultancy::Service.where(code: 'MCF2.2.1').first
    required_region = Nuts2Region.find_by(code: 'UKC2')

    choose 'help_needed_management_consultants'
    click_on 'Continue'

    choose 'Lot MCF2.2 - Procurement, Supply Chain and Commercial Consultancy Services'
    click_on I18n.t('common.submit')

    check required_service.name
    click_on I18n.t('common.submit')

    check required_region.name
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Supplier results')
    expect(page).to have_text('1 company')
    expect(page).to have_text(/Mega Group PLC/)
  end

  scenario 'Buyer wants to buy complex & transformation services (MCF2 Lot 3)' do
    visit_management_consultancy_start

    required_service = ManagementConsultancy::Service.where(code: 'MCF2.3.10').first
    required_region = Nuts2Region.find_by(code: 'UKD1')

    choose 'help_needed_management_consultants'
    click_on 'Continue'

    choose 'Lot MCF2.3 - Complex and Transformation Consultancy Services'
    click_on I18n.t('common.submit')

    check required_service.name
    click_on I18n.t('common.submit')

    check required_region.name
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Supplier results')
    expect(page).to have_text('1 company')
    expect(page).to have_text(/Johnson LLP/)
  end

  scenario 'Buyer wants to buy strategic services (MCF2 Lot 4)' do
    visit_management_consultancy_start

    required_service = ManagementConsultancy::Service.where(code: 'MCF2.4.10').first
    required_region = Nuts2Region.find_by(code: 'UKD3')

    choose 'help_needed_management_consultants'
    click_on 'Continue'

    choose 'Lot MCF2.4 - Strategic Consultancy Services'
    click_on I18n.t('common.submit')

    check required_service.name
    click_on I18n.t('common.submit')

    check required_region.name
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Supplier results')
    expect(page).to have_text('1 company')
    expect(page).to have_text(/Aardvark Ltd/)
  end

  scenario 'Buyer needs a different framework' do
    visit_management_consultancy_start

    choose 'help_needed_g_cloud'
    click_on 'Continue'

    expect(page).to have_css('h1', text: 'You need a different framework')
  end

  scenario 'Buyer doesn’t pick a framework' do
    visit_management_consultancy_start
    click_on 'Continue'

    expect(page).to have_css('.govuk-error-message', text: 'Select what you need')
  end
end
