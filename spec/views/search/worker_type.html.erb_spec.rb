require 'rails_helper'

RSpec.describe 'search/worker_type.html.erb' do
  let(:error) { nil }
  let(:journey) { instance_double('Journey', error: error) }

  before do
    assign(:journey, journey)
    assign(:form_path, '/')
  end

  it 'stores answer to looking-for question in hidden field' do
    assign(:back_path, '/')
    params[:looking_for] = 'looking-for'
    render
    expect(rendered).to have_css('input[name="looking_for"][value="looking-for"]', visible: false)
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
