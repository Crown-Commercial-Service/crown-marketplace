require 'rails_helper'

RSpec.describe 'search/school_postcode.html.erb' do
  before do
    @back_path = '/'
    @form_path = '/'
  end

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

  it 'stores answer to school payroll question in hidden field' do
    params[:school_payroll] = 'school-payroll'
    render
    expect(rendered).to have_css('input[name="school_payroll"][value="school-payroll"]', visible: false)
  end
end
