require 'rails_helper'

RSpec.describe 'shared/_error_summary.html.erb' do
  let(:step) { Class.new { include Steppable } }
  let(:errors) { ActiveModel::Errors.new(step) }

  before do
    view.extend(ApplicationHelper)
  end

  context 'when errors are empty' do
    before do
      render partial: 'shared/error_summary', locals: { errors: }
    end

    it 'does not render error summary' do
      expect(rendered).to be_blank
    end
  end

  context 'when errors are present' do
    before do
      errors.add(:attribute_name, 'error-message')
      render partial: 'shared/error_summary', locals: { errors: errors, multiple: false }
    end

    it 'displays the error summary' do
      expect(rendered).to have_css('.govuk-error-summary')
    end

    it 'links to error in the form' do
      expect(rendered).to have_link('error-message', href: '#attribute_name-error')
    end
  end

  context 'when there are multiple errors for the same attribute and we want only 1 error' do
    before do
      errors.add(:attribute_name, 'error-message-1')
      errors.add(:attribute_name, 'error-message-2')
      render partial: 'shared/error_summary', locals: { errors: }
    end

    it 'displays the first error message in the summary' do
      expect(rendered).to have_link('error-message-1', href: '#attribute_name-error')
    end

    it 'does not display the second error message in the summary' do
      expect(rendered).to have_no_link('error-message-2')
    end
  end

  context 'when there are multiple errors for the multiple attributes and we want the first attribute and the first error' do
    before do
      errors.add(:attribute_name, 'error-message-1')
      errors.add(:attribute_name, 'error-message-2')
      errors.add(:attribute_name_2, 'error-message-3')
      errors.add(:attribute_name_2, 'error-message-4')
      render partial: 'shared/error_summary', locals: { errors: }
    end

    it 'displays the first error message for the first attribute in the summary' do
      expect(rendered).to have_link('error-message-1', href: '#attribute_name-error')
    end

    it 'does not display the second error message for the first attribute in the summary' do
      expect(rendered).to have_no_link('error-message-2')
    end

    it 'does not displays the first error message for the second attribute in the summary' do
      expect(rendered).to have_link('error-message-3', href: '#attribute_name_2-error')
    end

    it 'does not display the second error message for the second attribute in the summary' do
      expect(rendered).to have_no_link('error-message-4', href: '#attribute_name_2-error')
    end
  end

  context 'when there are multiple errors for the multiple attributes and we want more than 1 attribute' do
    before do
      errors.add(:attribute_name, 'error-message-1')
      errors.add(:attribute_name, 'error-message-2')
      errors.add(:attribute_name_2, 'error-message-3')
      errors.add(:attribute_name_2, 'error-message-4')
      render partial: 'shared/error_summary', locals: { errors: errors, multiple: true }
    end

    it 'displays the first error message for the first attribute in the summary' do
      expect(rendered).to have_link('error-message-1', href: '#attribute_name-error')
    end

    it 'does not display the second error message for the first attribute in the summary' do
      expect(rendered).to have_no_link('error-message-2')
    end

    it 'displays the first error message for the second attribute in the summary' do
      expect(rendered).to have_link('error-message-3', href: '#attribute_name_2-error')
    end

    it 'does not display the second error message for the second attribute in the summary' do
      expect(rendered).to have_no_link('error-message-4', href: '#attribute_name_2-error')
    end
  end
end
