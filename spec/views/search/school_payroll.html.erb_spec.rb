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
