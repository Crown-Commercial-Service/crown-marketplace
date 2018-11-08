require 'rails_helper'

module FacilitiesManagement
  RSpec.describe Steps::SupplierRegion, type: :model do
    subject(:step) { described_class.new(region_codes: %w[UKC1]) }

    let(:model_key) { 'activemodel.errors.models.facilities_management/steps/supplier_region' }

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
  end
end
