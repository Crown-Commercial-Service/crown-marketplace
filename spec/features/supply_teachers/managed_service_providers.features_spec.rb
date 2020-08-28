require 'rails_helper'

RSpec.feature 'Managed service providers', type: :feature do
  before do
    user = FactoryBot.create(:user, :without_detail, roles: %i[buyer st_access])
    login_as(user, scope: :user)
  end

  scenario 'Answers should not be pre-selected' do
    visit_supply_teachers_start

    expect(page).not_to have_checked_field('Yes')
    expect(page).not_to have_checked_field('No')
  end

  scenario 'Buyer wants to hire a master vendor managed service' do
    supplier = create(:supply_teachers_supplier)

    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt', term: 'one_week', mark_up: 0.11)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt', term: 'twelve_weeks', mark_up: 0.12)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt', term: 'more_than_twelve_weeks', mark_up: 0.13)

    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt_sen', term: 'one_week', mark_up: 0.21)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt_sen', term: 'twelve_weeks', mark_up: 0.22)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'qt_sen', term: 'more_than_twelve_weeks', mark_up: 0.23)

    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'nominated', mark_up: 0.30)
    create(:supply_teachers_master_vendor_rate,
           supplier: supplier, job_type: 'fixed_term', mark_up: 0.40)

    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider')
    click_on I18n.t('common.submit')

    expect(page).to have_css('h1', text: 'Master vendor managed service')
    expect(page).to have_css('h2', text: supplier.name)

    expect(page).to have_rates(job_type: 'Qualified teacher: non-SEN roles', percentages: [11.0, 12.0, 13.0])
    expect(page).to have_rates(job_type: 'Qualified teacher: SEN roles', percentages: [21.0, 22.0, 23.0])
    expect(page).to have_rates(job_type: 'A specific person', percentages: [30.0, 30.0, 30.0])
    expect(page).to have_rates(job_type: 'Employed directly', percentages: [40.0, 40.0, 40.0])
  end

  scenario 'Buyer changes mind about hiring a managed service provider' do
    visit_supply_teachers_start

    choose I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider')
    click_on I18n.t('common.submit')

    click_on I18n.t('layouts.application.back')

    expect(page).to have_checked_field(I18n.t('supply_teachers.journey.looking_for.answer_managed_service_provider'))
  end

  private

  def have_rates(job_type:, percentages:, amount: nil)
    rate_patterns = if percentages.any?
                      percentages.map { |p| rate_pattern(p) }
                    else
                      [daily_fee_pattern(amount)]
                    end
    combined_pattern = [Regexp.escape(job_type), *rate_patterns].join('\s+')
    have_text(Regexp.new(combined_pattern))
  end

  def rate_pattern(percentage)
    format('%.1f%%', percentage).sub('.', Regexp.escape('.'))
  end

  def daily_fee_pattern(amount)
    "£#{amount}".sub('.', Regexp.escape('.'))
  end
end
