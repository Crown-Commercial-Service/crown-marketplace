require 'rails_helper'

RSpec.describe 'journey/school_postcode.html.erb' do
  let(:step) { Steps::SchoolPostcode.new }
  let(:errors) { ActiveModel::Errors.new(step) }
  let(:journey) { instance_double('Journey', errors: errors) }

  before do
    assign(:journey, journey)
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

  it 'stores answer to payroll-provider question in hidden field' do
    params[:payroll_provider] = 'payroll-provider'
    render
    expect(rendered).to have_css('input[name="payroll_provider"][value="payroll-provider"]', visible: false)
  end

  it 'does not display the error summary' do
    render
    expect(rendered).not_to have_css('.govuk-error-summary')
  end

  it 'does not include any error message classes' do
    render
    expect(rendered).not_to have_css('.govuk-form-group--error')
    expect(rendered).not_to have_css('.govuk-error-message')
    expect(rendered).not_to have_css('.govuk-input--error')
  end

  context 'when the journey has an error' do
    before do
      errors.add(:location, 'error-message')
      render
    end

    it 'displays the error summary' do
      expect(rendered).to have_css('.govuk-error-summary')
    end

    it 'adds the form group error class' do
      expect(rendered).to have_css('.govuk-form-group.govuk-form-group--error')
    end

    it 'adds the message to the field with the error' do
      expect(rendered).to have_css('#location-error.govuk-error-message', text: 'error-message')
    end

    it 'adds the error class to the postcode input' do
      expect(rendered).to have_css('input[name=postcode][type=text].govuk-input--error')
    end
  end
end
