require 'rails_helper'

RSpec.feature 'Facilities Managment', type: :feature do
  scenario 'Answers should not be pre-selected' do
    visit_facilities_management_home
    click_on 'Start now'

    expect(page).not_to have_checked_field(I18n.t('journey.value_band.answer_under1_5m'))
    expect(page).not_to have_checked_field(I18n.t('journey.value_band.answer_under7m'))
    expect(page).not_to have_checked_field(I18n.t('journey.value_band.answer_under50m'))
    expect(page).not_to have_checked_field(I18n.t('journey.value_band.answer_over50m'))
  end

  scenario 'Buyer wants to buy from lot 1a' do
    visit_facilities_management_home
    click_on 'Start now'

    choose I18n.t('journey.value_band.answer_under1_5m')
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Which regions do you need the service in?')

    check 'Cumbria'
    check 'Cheshire'
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Lot 1a suppliers')
  end

  scenario 'Buyer changes mind about buying from lot 1a' do
    visit_facilities_management_home
    click_on 'Start now'

    choose I18n.t('journey.value_band.answer_under1_5m')
    click_on I18n.t('common.submit')

    click_on I18n.t('layouts.application.back')

    expect(page).to have_checked_field(I18n.t('journey.value_band.answer_under1_5m'))
  end

  scenario 'Buyer wants to buy from lot 1a, under 7m' do
    visit_facilities_management_home
    click_on 'Start now'

    choose I18n.t('journey.value_band.answer_under7m')
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Which regions do you need the service in?')

    check 'Cumbria'
    check 'Cheshire'
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Lot 1a suppliers')
  end

  scenario 'Buyer changes mind about buying from lot 1a, under 7m' do
    visit_facilities_management_home
    click_on 'Start now'

    choose I18n.t('journey.value_band.answer_under7m')
    click_on I18n.t('common.submit')

    click_on I18n.t('layouts.application.back')

    expect(page).to have_checked_field(I18n.t('journey.value_band.answer_under7m'))
  end

  scenario 'Buyer wants to buy from lot 1b' do
    visit_facilities_management_home
    click_on 'Start now'

    choose I18n.t('journey.value_band.answer_under50m')
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Lot 1b suppliers')
  end

  scenario 'Buyer changes mind about buying from lot 1b' do
    visit_facilities_management_home
    click_on 'Start now'

    choose I18n.t('journey.value_band.answer_under50m')
    click_on I18n.t('common.submit')

    click_on I18n.t('layouts.application.back')

    expect(page).to have_checked_field(I18n.t('journey.value_band.answer_under50m'))
  end

  scenario 'Buyer wants to buy from lot 1c' do
    visit_facilities_management_home
    click_on 'Start now'

    choose I18n.t('journey.value_band.answer_over50m')
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Lot 1c suppliers')
  end

  scenario 'Buyer changes mind about buying from lot 1c' do
    visit_facilities_management_home
    click_on 'Start now'

    choose I18n.t('journey.value_band.answer_over50m')
    click_on I18n.t('common.submit')

    click_on I18n.t('layouts.application.back')

    expect(page).to have_checked_field(I18n.t('journey.value_band.answer_over50m'))
  end
end
