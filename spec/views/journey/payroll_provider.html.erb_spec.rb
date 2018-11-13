require 'rails_helper'

RSpec.describe 'journey/payroll_provider.html.erb' do
  let(:step) { SupplyTeachers::Steps::PayrollProvider.new }
  let(:errors) { ActiveModel::Errors.new(step) }
  let(:journey) { instance_double('Journey', errors: errors) }

  before do
    view.extend(ApplicationHelper)
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

  it 'does not include aria-describedby attribute' do
    render
    expect(rendered).not_to have_css('fieldset[aria-describedby]')
  end

  it 'does not display the error summary' do
    render
    expect(rendered).not_to have_css('.govuk-error-summary')
  end

  it 'does not include any error message classes' do
    render
    expect(rendered).not_to have_css('.govuk-form-group--error')
    expect(rendered).not_to have_css('.govuk-error-message')
  end

  it 'does not set the page title prefix' do
    render
    expect(view.content_for(:page_title_prefix)).to be_nil
  end

  context 'when the journey has an error' do
    before do
      errors.add(:payroll_provider, 'error-message')
      render
    end

    it 'links the fieldset to the error message' do
      expect(rendered).to have_css('fieldset[aria-describedby="payroll_provider-error"]')
    end

    it 'displays the error summary' do
      expect(rendered).to have_css('.govuk-error-summary')
    end

    it 'adds the form group error class' do
      expect(rendered).to have_css('.govuk-form-group.govuk-form-group--error')
    end

    it 'adds the message to the field with the error' do
      expect(rendered).to have_css('#payroll_provider-error.govuk-error-message', text: 'error-message')
    end

    it 'adds an error prefix to the page title' do
      render
      expect(view.content_for(:page_title_prefix)).to match(t('layouts.application.error_prefix'))
    end
  end
end
