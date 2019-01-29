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
      job_type: 'qt_sen',
      term: 'twelve_weeks',
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
      job_type: 'qt_sen',
      term: 'twelve_weeks',
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

  scenario 'Buyer can calculate the agency mark-up' do
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_worker')
    click_on I18n.t('common.submit')

    choose 'Yes'
    click_on I18n.t('common.submit')

    choose 'Yes'
    click_on I18n.t('common.submit')

    fill_in 'postcode', with: 'WC2B 6TE'
    choose '4 weeks to 8 weeks'
    choose 'Qualified teacher: SEN roles'
    click_on I18n.t('common.submit')

    within page.find('.supplier-record:first') do
      fill_in 'Enter daily rate', with: '150'
    end

    click_on 'Calculate the fee'

    within page.find('.supplier-record:first') do
      expect(page).to have_css('.supplier-record__worker-cost', text: '£115.38')
      expect(page).to have_css('.supplier-record__agency-fee', text: '£34.62')
    end
  end

  scenario 'Buyer can calculate the agency mark-up via AJAX', js: true do
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_worker'), visible: false
    click_on I18n.t('common.submit')

    choose 'Yes', visible: false
    click_on I18n.t('common.submit')

    choose 'Yes', visible: false
    click_on I18n.t('common.submit')

    fill_in 'postcode', with: 'WC2B 6TE'
    choose '4 weeks to 8 weeks', visible: false
    choose 'Qualified teacher: SEN roles', visible: false
    click_on I18n.t('common.submit')

    branches = page.all('.supplier-record')

    within branches.first do
      fill_in 'Enter daily rate', with: '200'
      expect(page).to have_css('.supplier-record__worker-cost', text: '£153.85')
      expect(page).to have_css('.supplier-record__agency-fee', text: '£46.15')
    end
  end
end
