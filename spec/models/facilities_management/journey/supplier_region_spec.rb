require 'rails_helper'

RSpec.describe FacilitiesManagement::Journey::SupplierRegion, type: :model do
  subject(:step) { described_class.new(region_codes: %w[UKC1]) }

  let(:model_key) { 'activemodel.errors.models.facilities_management/journey/supplier_region' }

  it { is_expected.to be_valid }

  describe '#regions' do
    it 'returns the regions' do
      expect(step.regions).to be_an(Array)
      expect(step.regions.first.code).to eq('UKC1')
    end
  end

  context 'when region_codes does not contain at least 1 code' do
    before do
      step.region_codes = []
    end

    it { is_expected.not_to be_valid }

    it 'obtains the error message from an I18n translation' do
      step.valid?
      expect(step.errors[:region_codes]).to include(
        I18n.t("#{model_key}.attributes.region_codes.too_short")
      )
    end
  end
end
