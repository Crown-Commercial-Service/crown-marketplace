require 'rails_helper'

RSpec.feature 'Temp to Perm fee calculator', type: :feature do
  scenario 'Making a worker permanent after 12 weeks and giving at least 4 weeks notice' do
    visit_temp_to_perm_calculator

    fill_in_contract_start_date Date.parse('2018-09-03')

    fill_in_hire_date Date.parse('2018-11-26')

    fill_in 'days_per_week', with: 5

    fill_in 'day_rate', with: 110

    fill_in 'markup_rate', with: 10

    fill_in_notice_date Date.parse('2018-10-29')

    click_on I18n.t('common.submit')

    expect_fee 0
  end

  scenario 'Hiring a worker within 12 weeks of the start of their contract' do
    visit_temp_to_perm_calculator

    fill_in_contract_start_date Date.parse('2018-09-03')

    fill_in_hire_date Date.parse('2018-11-19')

    fill_in 'days_per_week', with: 5

    fill_in 'day_rate', with: 110

    fill_in 'markup_rate', with: 10

    click_on I18n.t('common.submit')

    expect_fee 50
  end

  scenario 'Hiring a worker within 12 weeks of the start of their contract because of school holidays' do
    visit_temp_to_perm_calculator

    fill_in_contract_start_date Date.parse('2018-09-03')

    fill_in_hire_date Date.parse('2018-11-26')

    fill_in 'days_per_week', with: 5

    fill_in 'day_rate', with: 110

    fill_in 'markup_rate', with: 10

    fill_in_holiday 1, Date.parse('2018-09-03'), Date.parse('2018-09-07')

    fill_in_holiday 2, Date.parse('2018-09-10'), Date.parse('2018-09-14')

    click_on I18n.t('common.submit')

    expect_fee 100
  end

  scenario 'Hiring a worker after 12 weeks of the start of their contract but without enough notice period' do
    visit_temp_to_perm_calculator

    fill_in_contract_start_date Date.parse('2018-09-03')

    fill_in_hire_date Date.parse('2018-11-26')

    fill_in 'days_per_week', with: 5

    fill_in 'day_rate', with: 110

    fill_in 'markup_rate', with: 10

    fill_in_notice_date Date.parse('2018-11-26')

    click_on I18n.t('common.submit')

    expect_fee 200
  end

  private

  def visit_temp_to_perm_calculator
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_calculate_temp_to_perm_fee')
    click_on I18n.t('common.submit')
  end

  def fill_in_contract_start_date(date)
    fill_in 'contract_start_date_day', with: date.day
    fill_in 'contract_start_date_month', with: date.month
    fill_in 'contract_start_date_year', with: date.year
  end

  def fill_in_hire_date(date)
    fill_in 'hire_date_day', with: date.day
    fill_in 'hire_date_month', with: date.month
    fill_in 'hire_date_year', with: date.year
  end

  def fill_in_notice_date(date)
    fill_in 'notice_date_day', with: date.day
    fill_in 'notice_date_month', with: date.month
    fill_in 'notice_date_year', with: date.year
  end

  def fill_in_holiday(number, start_date, end_date)
    fill_in "holiday_#{number}_start_date_day", with: start_date.day
    fill_in "holiday_#{number}_start_date_month", with: start_date.month
    fill_in "holiday_#{number}_start_date_year", with: start_date.year
    fill_in "holiday_#{number}_end_date_day", with: end_date.day
    fill_in "holiday_#{number}_end_date_month", with: end_date.month
    fill_in "holiday_#{number}_end_date_year", with: end_date.year
  end

  def expect_fee(fee)
    expect(page).to have_text("Based on the information provided you could be charged £#{fee}")
  end
end
