require 'rails_helper'

RSpec.describe SupplyTeachers::Steps::PayrollProvider, type: :model do
  subject(:step) { described_class.new(payroll_provider: 'school') }

  let(:model_key) { 'activemodel.errors.models.supply_teachers/steps/payroll_provider' }

  it { is_expected.to be_valid }

  context 'when payroll_provider is not valid' do
    before do
      step.payroll_provider = 'unacceptable-value'
    end

    it { is_expected.not_to be_valid }

    it 'obtains the error message from an I18n translation' do
      step.valid?
      expect(step.errors[:payroll_provider]).to include(
        I18n.t("#{model_key}.attributes.payroll_provider.inclusion")
      )
    end
  end
end
