require 'rails_helper'

RSpec.describe FacilitiesManagement::Steps::ValueBand, type: :model do
  subject(:step) { described_class.new(value_band: 'under1_5m') }

  let(:model_key) { 'activemodel.errors.models.facilities_management/steps/value_band' }

  it { is_expected.to be_valid }

  context 'when value band is not in list of acceptable values' do
    before do
      step.value_band = 'unacceptable-value'
    end

    it { is_expected.not_to be_valid }

    it 'obtains the error message from an I18n translation' do
      step.valid?
      expect(step.errors[:value_band]).to include(
        I18n.t("#{model_key}.attributes.value_band.inclusion")
      )
    end
  end
end
