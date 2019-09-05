require 'rails_helper'

RSpec.describe LegalServices::Journey::ChooseRegions, type: :model do
  subject(:step) { described_class.new(region_codes: %w[UKC UKD]) }

  let(:model_key) { 'activemodel.errors.models.legal_services/journey/choose_regions' }

  it { is_expected.to be_valid }

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

  describe '.full_national_coverage_or_selected_regions' do
    context 'when region_codes contains full national coverage and regions' do
      before do
        step.region_codes = ['UK', 'UKC']
      end

      it { is_expected.not_to be_valid }

      it 'obtains the error message from an I18n translation' do
        step.valid?
        expect(step.errors[:region_codes]).to include(
          I18n.t("#{model_key}.attributes.region_codes.full_national_coverage")
        )
      end
    end

    context 'when region_codes only contains UK' do
      before do
        step.region_codes = ['UK']
      end

      it { is_expected.to be_valid }
    end
  end
end
