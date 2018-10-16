require 'rails_helper'

RSpec.describe 'search/school_payroll_question.html.erb' do
  it 'stores answer to hire via agency question in hidden field' do
    params[:hire_via_agency] = 'hire-via-agency'
    render
    expect(rendered).to have_css('input[name="hire_via_agency"][value="hire-via-agency"]', visible: false)
  end

  it 'stores answer to nominated worker question in hidden field' do
    params[:nominated_worker] = 'nominated-worker'
    render
    expect(rendered).to have_css('input[name="nominated_worker"][value="nominated-worker"]', visible: false)
  end

  it 'selects "yes" if school payroll is "yes"' do
    params[:school_payroll] = 'yes'
    render
    expect(rendered).to have_css('input[type="radio"][name="school_payroll"][value="yes"][checked]')
  end

  it 'selects "no" if school payroll is "no"' do
    params[:school_payroll] = 'no'
    render
    expect(rendered).to have_css('input[type="radio"][name="school_payroll"][value="no"][checked]')
  end
end
