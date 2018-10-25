require 'rails_helper'

RSpec.describe 'search/school_postcode.html.erb' do
  before do
    @back_path = '/'
    @form_path = '/'
  end

  it 'stores answer to looking-for question in hidden field' do
    params[:looking_for] = 'looking-for'
    render
    expect(rendered).to have_css('input[name="looking_for"][value="looking-for"]', visible: false)
  end

  it 'stores answer to worker-type question in hidden field' do
    params[:worker_type] = 'worker-type'
    render
    expect(rendered).to have_css('input[name="worker_type"][value="worker-type"]', visible: false)
  end

  it 'stores answer to payroll-provider question in hidden field' do
    params[:payroll_provider] = 'payroll-provider'
    render
    expect(rendered).to have_css('input[name="payroll_provider"][value="payroll-provider"]', visible: false)
  end

  it 'does not include any error message classes' do
    render
    expect(rendered).not_to have_css('.govuk-form-group--error')
    expect(rendered).not_to have_css('.govuk-error-message')
  end

  context 'when the flash contains an error' do
    before do
      flash[:error] = 'error-message'
      render
    end

    it 'adds the form group error class' do
      expect(rendered).to have_css('.govuk-form-group.govuk-form-group--error')
    end

    it 'adds the message to the field with the error' do
      expect(rendered).to have_css('.govuk-error-message', text: 'error-message')
    end
  end
end
