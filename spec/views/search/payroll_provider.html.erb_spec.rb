require 'rails_helper'

RSpec.describe 'search/payroll_provider.html.erb' do
  before do
    assign(:back_path, '/')
    assign(:form_path, '/')
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
