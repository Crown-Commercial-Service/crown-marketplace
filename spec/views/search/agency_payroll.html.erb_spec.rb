require 'rails_helper'

RSpec.describe 'search/agency_payroll.html.erb' do
  before do
    assign(:form_path, '/')
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
