require 'rails_helper'

RSpec.describe 'search/looking_for.html.erb' do
  let(:error) { nil }
  let(:journey) { instance_double('Journey', error: error) }

  before do
    assign(:journey, journey)
    assign(:form_path, '/')
  end

  it 'does not include any error message classes' do
    render
    expect(rendered).not_to have_css('.govuk-form-group--error')
    expect(rendered).not_to have_css('.govuk-error-message')
  end

  context 'when the journey has an error' do
    let(:error) { 'error-message' }

    before do
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
