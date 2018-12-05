require 'rails_helper'

RSpec.describe 'shared/_error_summary.html.erb' do
  let(:step) { Class.new { include Steppable } }
  let(:errors) { ActiveModel::Errors.new(step) }

  before do
    view.extend(ApplicationHelper)
  end

  context 'when errors are empty' do
    before do
      render partial: 'shared/error_summary', locals: { errors: errors }
    end

    it 'does not render error summary' do
      expect(rendered).to be_blank
    end
  end

  context 'when errors are present' do
    before do
      errors.add(:attribute_name, 'error-message')
      render partial: 'shared/error_summary', locals: { errors: errors }
    end

    it 'displays the error summary' do
      expect(rendered).to have_css('.govuk-error-summary')
    end

    it 'links to error in the form' do
      expect(rendered).to have_link('error-message', href: '#attribute_name-error')
    end
  end

  context 'when there are multiple errors for the same attribute' do
    before do
      errors.add(:attribute_name, 'error-message-1')
      errors.add(:attribute_name, 'error-message-2')
      render partial: 'shared/error_summary', locals: { errors: errors }
    end

    it 'displays the first error message in the summary' do
      expect(rendered).to have_link('error-message-1', href: '#attribute_name-error')
    end

    it 'does not display the second error message in the summary' do
      expect(rendered).not_to have_link('error-message-2')
    end
  end
end
