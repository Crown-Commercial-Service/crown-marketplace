require 'rails_helper'

RSpec.describe ManagementConsultancy::Steps::ChooseExpenses, type: :model do
  subject(:step) { described_class.new(expenses: 'paid') }

  let(:model_key) { 'activemodel.errors.models.management_consultancy/steps/choose_expenses' }

  it { is_expected.to be_valid }

  context 'when expenses is not valid' do
    before do
      step.expenses = 'unacceptable-value'
    end

    it { is_expected.not_to be_valid }

    it 'obtains the error message from an I18n translation' do
      step.valid?
      expect(step.errors[:expenses]).to include(
        I18n.t("#{model_key}.attributes.expenses.inclusion")
      )
    end
  end
end
