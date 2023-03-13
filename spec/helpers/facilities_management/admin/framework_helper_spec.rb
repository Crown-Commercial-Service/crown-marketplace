require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::FrameworkHelper do
  describe '.framework_expired_warning' do
    let(:result) { helper.framework_expired_warning('The framework has expired') }

    before { @framework_has_expired = framework_has_expired }

    context 'when the framework has expired' do
      let(:framework_has_expired) { true }

      it 'renders HTML with the text' do
        expect(result).to eq('<div class="govuk-warning-text"><span class="govuk-warning-text__icon" aria-hidden="true">!</span><strong class="govuk-warning-text__text"><span class="govuk-warning-text__assistive">Warning</span>The framework has expired</strong></div>')
      end
    end

    context 'when the framework has not epxired' do
      let(:framework_has_expired) { false }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end
