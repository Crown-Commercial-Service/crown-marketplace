require 'rails_helper'

RSpec.describe 'search/school_payroll.html.erb' do
  before do
    @back_path = '/'
    @form_path = '/'
  end

  it 'stores answer to hire via agency question in hidden field' do
    params[:looking_for] = 'looking-for'
    render
    expect(rendered).to have_css('input[name="looking_for"][value="looking-for"]', visible: false)
  end

  it 'stores answer to nominated worker question in hidden field' do
    params[:worker_type] = 'worker-type'
    render
    expect(rendered).to have_css('input[name="worker_type"][value="worker-type"]', visible: false)
  end

  it 'selects "school" if payroll provider is "school"' do
    params[:payroll_provider] = 'school'
    render
    expect(rendered).to have_css('input[type="radio"][name="payroll_provider"][value="school"][checked]')
  end

  it 'selects "agency" if payroll provider is "agency"' do
    params[:payroll_provider] = 'agency'
    render
    expect(rendered).to have_css('input[type="radio"][name="payroll_provider"][value="agency"][checked]')
  end
end
