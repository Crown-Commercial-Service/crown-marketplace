require 'rails_helper'

RSpec.feature 'Temp to Perm fee calculator', type: :feature do
  let(:start_of_1st_week)  { Date.parse('Mon 3 Sep 2018') }
  let(:start_of_2nd_week)  { Date.parse('Mon 10 Sep 2018') }
  let(:start_of_3rd_week)  { Date.parse('Mon 17 Sep 2018') }
  let(:start_of_4th_week)  { Date.parse('Mon 24 Sep 2018') }
  let(:start_of_5th_week)  { Date.parse('Mon 1 Oct 2018') }
  let(:start_of_6th_week)  { Date.parse('Mon 8 Oct 2018') }
  let(:start_of_7th_week)  { Date.parse('Mon 15 Oct 2018') }
  let(:start_of_8th_week)  { Date.parse('Mon 22 Oct 2018') }
  let(:start_of_9th_week)  { Date.parse('Mon 29 Oct 2018') }
  let(:start_of_10th_week) { Date.parse('Mon 5 Nov 2018') }
  let(:start_of_11th_week) { Date.parse('Mon 12 Nov 2018') }
  let(:start_of_12th_week) { Date.parse('Mon 19 Nov 2018') }
  let(:start_of_13th_week) { Date.parse('Mon 26 Nov 2018') }

  scenario 'Making a worker permanent after 12 weeks and giving at least 4 weeks notice' do
    visit_temp_to_perm_calculator

    fill_in_contract_start_date start_of_1st_week
    fill_in_hire_date start_of_13th_week
    fill_in 'days_per_week', with: 5
    fill_in 'day_rate', with: 110
    fill_in 'markup_rate', with: 10
    fill_in_notice_date start_of_9th_week
    click_on I18n.t('common.submit')

    expect_fee 0
  end

  scenario 'Making a worker permanent within 12 weeks of the start of their contract' do
    visit_temp_to_perm_calculator

    fill_in_contract_start_date start_of_1st_week
    fill_in_hire_date start_of_12th_week
    fill_in 'days_per_week', with: 5
    fill_in 'day_rate', with: 110
    fill_in 'markup_rate', with: 10
    click_on I18n.t('common.submit')

    expect_fee 50
  end

  scenario 'Making a worker permanent within 12 weeks of the start of their contract because of school holidays' do
    visit_temp_to_perm_calculator

    fill_in_contract_start_date start_of_1st_week
    fill_in_hire_date start_of_13th_week
    fill_in 'days_per_week', with: 5
    fill_in 'day_rate', with: 110
    fill_in 'markup_rate', with: 10
    fill_in_holiday 1, start_of_1st_week, start_of_1st_week.end_of_week
    fill_in_holiday 2, start_of_2nd_week, start_of_2nd_week.end_of_week
    click_on I18n.t('common.submit')

    expect_fee 100
  end

  scenario 'Making a worker permanent after 12 weeks of the start of their contract but without enough notice period' do
    visit_temp_to_perm_calculator

    fill_in_contract_start_date start_of_1st_week
    fill_in_hire_date start_of_13th_week
    fill_in 'days_per_week', with: 5
    fill_in 'day_rate', with: 110
    fill_in 'markup_rate', with: 10
    fill_in_notice_date start_of_13th_week
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
