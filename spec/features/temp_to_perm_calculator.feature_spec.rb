require 'rails_helper'

RSpec.feature 'Temp to Perm fee calculator', type: :feature do
  scenario 'Buyer completes the calculation' do
    visit_temp_to_perm_calculator_home
    click_on 'Start now'

    fill_in 'Day', with: 12
    fill_in 'Month', with: 11
    fill_in 'Year', with: 2018
    click_on I18n.t('common.submit')

    fill_in 'Day', with: 19
    fill_in 'Month', with: 11
    fill_in 'Year', with: 2018
    click_on I18n.t('common.submit')

    fill_in 'days_per_week', with: 5
    click_on I18n.t('common.submit')

    fill_in 'day_rate', with: 600
    click_on I18n.t('common.submit')

    fill_in 'markup_rate', with: 30
    click_on I18n.t('common.submit')

    fill_in 'school_holidays', with: 0
    click_on I18n.t('common.submit')

    expect(page).to have_text('Based on the information provided you could be charged £7,615.38')
  end
end
