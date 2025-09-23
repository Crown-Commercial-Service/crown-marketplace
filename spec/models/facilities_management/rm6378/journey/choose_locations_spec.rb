require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Journey::ChooseLocations do
  let(:choose_locations) { described_class.new(region_codes:, annual_contract_value:) }
  let(:region_codes) { ['UKC1', 'UKC2'] }
  let(:annual_contract_value) { 123_456 }

  describe 'validations' do
    context 'when no region codes are present' do
      let(:region_codes) { [] }

      it 'is not valid and has the correct error message' do
        expect(choose_locations.valid?).to be false
        expect(choose_locations.errors[:region_codes].first).to eq 'Select at least one region you need to include in your procurement'
      end
    end

    context 'when region codes are present' do
      it 'is valid' do
        expect(choose_locations.valid?).to be true
      end
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::AnnualContractValue' do
      expect(choose_locations.next_step_class).to be FacilitiesManagement::RM6378::Journey::AnnualContractValue
    end
  end

  describe '.permit_list' do
    it 'returns a list of the permitted attributes' do
      expect(described_class.permit_list).to eq [:annual_contract_value, { region_codes: [] }]
    end
  end

  describe '.permitted_keys' do
    it 'returns a list of the permitted keys' do
      expect(described_class.permitted_keys).to eq %i[region_codes annual_contract_value]
    end
  end

  describe '.slug' do
    it 'returns choose-locations' do
      expect(choose_locations.slug).to eq 'choose-locations'
    end
  end

  describe '.template' do
    it 'returns journey/choose_locations' do
      expect(choose_locations.template).to eq 'journey/choose_locations'
    end
  end

  describe '.final?' do
    it 'returns false' do
      expect(choose_locations.final?).to be false
    end
  end

  describe '.regions_grouped_by_category' do
    let(:result) { choose_locations.regions_grouped_by_category.map { |category, regions| [category, regions.length] } }

    # rubocop:disable RSpec/ExampleLength
    it 'services are grouped together as expected' do
      expect(result).to eq(
        [
          ['UKC', 2],
          ['UKD', 5],
          ['UKE', 4],
          ['UKF', 3],
          ['UKG', 3],
          ['UKH', 3],
          ['UKI', 5],
          ['UKJ', 4],
          ['UKK', 4],
          ['UKL', 12],
          ['UKM', 23],
          ['UKN', 5],
          ['OS0', 1]
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
