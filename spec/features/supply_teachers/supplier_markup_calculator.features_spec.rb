require 'rails_helper'

RSpec.feature 'Supplier mark-up calculator', type: :feature do
  before do
    Geocoder::Lookup::Test.add_stub(
      'WC2B 6TE', [{ 'coordinates' => [51.5149666, -0.119098] }]
    )
    holborn = create(:supply_teachers_supplier, name: 'holborn')
    create(
      :supply_teachers_rate,
      supplier: holborn,
      lot_number: 1,
      job_type: 'fixed_term',
      mark_up: 0.35
    )
    create(
      :supply_teachers_branch,
      supplier: holborn,
      location: Geocoding.point(latitude: 51.5149666, longitude: -0.119098)
    )
    westminster = create(:supply_teachers_supplier, name: 'westminster')
    create(
      :supply_teachers_rate,
      supplier: westminster,
      lot_number: 1,
      job_type: 'fixed_term',
      mark_up: 0.30
    )
    create(
      :supply_teachers_branch,
      supplier: westminster,
      location: Geocoding.point(latitude: 51.5185614, longitude: -0.1437991)
    )
  end

  after do
    Geocoder::Lookup::Test.reset
  end

  scenario 'Buyer can calculate the supplier mark-up' do
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_worker')
    click_on I18n.t('common.submit')

    choose 'Yes'
    click_on I18n.t('common.submit')

    choose 'No, I want to put the worker on our payroll'
    click_on I18n.t('common.submit')

    fill_in 'postcode', with: 'WC2B 6TE'
    click_on I18n.t('common.submit')

    within page.find('.supplier-record:first') do
      fill_in 'Enter daily rate', with: '150'
    end

    click_on 'Calculate mark-up'

    within page.find('.supplier-record:first') do
      expect(page).to have_css('.supplier-record__worker-cost', text: '£115.38')
      expect(page).to have_css('.supplier-record__supplier-fee', text: '£34.62')
    end
  end
end
