require 'rails_helper'

RSpec.describe 'search/school_postcode.html.erb' do
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

  it 'stores answer to payroll-provider question in hidden field' do
    params[:payroll_provider] = 'payroll-provider'
    render
    expect(rendered).to have_css('input[name="payroll_provider"][value="payroll-provider"]', visible: false)
  end
end
