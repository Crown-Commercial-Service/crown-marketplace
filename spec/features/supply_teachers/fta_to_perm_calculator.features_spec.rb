require 'rails_helper'

RSpec.feature 'FTA to Perm fee calculator', type: :feature, supply_teachers: true do
  include ActionView::Helpers::NumberHelper
  include Dateable
  include_context 'with fta dates'

  scenario 'Worker contract end date is more than 6 months ago' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_9_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_7_months_ago
    click_on I18n.t('common.submit')

    expect_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.no_fee.end_not_within_6_months')
  end

  scenario 'Worker contract end date is 6 months ago - 1 day' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_9_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_6_months_ago - 1.day
    click_on I18n.t('common.submit')

    expect_no_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.no_fee.end_not_within_6_months')
  end

  scenario 'Worker has been employed for 12 months or more' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_13_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_1_month_ago
    click_on I18n.t('common.submit')

    expect_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.no_fee.length_not_within_12_months')
  end

  scenario 'Worker has been employed for 12 months - 1 day' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_13_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_1_month_ago - 1.day
    click_on I18n.t('common.submit')

    expect_no_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.no_fee.length_not_within_12_months')
  end

  scenario 'The gap between contract end date and hire date is grater than or equal to 6 months' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_13_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_5_months_ago
    click_on I18n.t('common.submit')
    fill_in_hire_date date_1_month_from_now
    click_on I18n.t('common.submit')

    expect_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.no_fee.hire_not_within_6_months')
  end

  scenario 'The gap between contract end date and hire date is 6 months - 1.day' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_13_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_5_months_ago
    click_on I18n.t('common.submit')
    fill_in_hire_date date_1_month_from_now - 1.day
    click_on I18n.t('common.submit')

    expect_no_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.no_fee.hire_not_within_6_months')
  end

  scenario 'The gap between contract end date and hire date is less than 6 months' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_13_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_5_months_ago
    click_on I18n.t('common.submit')
    fill_in_hire_date date_0_months_ago
    click_on I18n.t('common.submit')

    expect_fee_text I18n.t('supply_teachers.journey.fta_to_perm_hire_date_notice.header_html', date: date_1_month_from_now.strftime('%d %b %Y'))
  end

  scenario 'Worker contract end date is less than 6 months, has been employed for less than 12 months and hire date is less than 6 months' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_13_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_5_months_ago
    click_on I18n.t('common.submit')
    fill_in_hire_date date_0_months_ago
    click_on I18n.t('common.submit')
    click_on I18n.t('supply_teachers.journey.fta_to_perm_hire_date_notice.submit')
    fill_in 'fixed_term_fee', with: '12000'
    click_on I18n.t('common.submit')

    expect_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.header') + ' ' + number_to_currency(12000 / difference_in_months(date_13_months_ago, date_5_months_ago).to_f * 12 - 12000)
  end

  scenario 'Worker contract length is 5 months - 1.day, fixed term fee is 2500 and hire date is less than 6 months' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_6_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_1_month_ago - 1.day
    click_on I18n.t('common.submit')
    fill_in_hire_date date_1_month_from_now
    click_on I18n.t('common.submit')
    click_on I18n.t('supply_teachers.journey.fta_to_perm_hire_date_notice.submit')
    fill_in 'fixed_term_fee', with: '2500'
    click_on I18n.t('common.submit')

    expect_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.header') + ' ' + number_to_currency(2500 / difference_in_months(date_6_months_ago, date_1_month_ago - 1.day) * 12 - 2500)
  end

  scenario 'Worker contract length is 5 + 1/2 months, fixed term fee is 2500 and hire date is less than 6 months' do
    visit_fta_to_perm_calculator

    fill_in_contract_start_date date_6_months_ago
    click_on I18n.t('common.submit')
    fill_in_contract_end_date date_1_month_ago - 12.days
    click_on I18n.t('common.submit')
    fill_in_hire_date date_1_month_from_now
    click_on I18n.t('common.submit')
    click_on I18n.t('supply_teachers.journey.fta_to_perm_hire_date_notice.submit')
    fill_in 'fixed_term_fee', with: '2500'
    click_on I18n.t('common.submit')

    expect_fee_text I18n.t('.supply_teachers.home.fta_to_perm_fee.header') + ' ' + number_to_currency(2500 / difference_in_months(date_6_months_ago, date_1_month_ago - 12.days) * 12 - 2500)
  end

  private

  def visit_fta_to_perm_calculator
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_calculate_fta_to_perm_fee')
    click_on I18n.t('common.submit')
  end

  def fill_in_contract_start_date(date)
    fill_in 'contract_start_date_day', with: date.day
    fill_in 'contract_start_date_month', with: date.month
    fill_in 'contract_start_date_year', with: date.year
  end

  def fill_in_contract_end_date(date)
    fill_in 'contract_end_date_day', with: date.day
    fill_in 'contract_end_date_month', with: date.month
    fill_in 'contract_end_date_year', with: date.year
  end

  def fill_in_hire_date(date)
    fill_in 'hire_date_day', with: date.day
    fill_in 'hire_date_month', with: date.month
    fill_in 'hire_date_year', with: date.year
  end

  def expect_fee_text(fee)
    expect(page).to have_text(fee)
  end

  def expect_no_fee_text(fee)
    expect(page).not_to have_text(fee)
  end
end
