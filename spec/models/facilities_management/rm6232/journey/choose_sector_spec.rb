require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::ChooseSector, type: :model do
  let(:choose_sector) { described_class.new(sector_code: sector_code, contract_cost: etimated_contract_cost) }
  let(:sector_code) { 3 }
  let(:etimated_contract_cost) { 123_456 }

  describe 'validations' do
    context 'when a sector has not been selected' do
      let(:sector_code) { nil }

      it 'is not valid and has the correct error message' do
        expect(choose_sector.valid?).to be false
        expect(choose_sector.errors[:sector_code].first).to eq 'Select the sector your organisation belongs to'
      end
    end

    context 'when a sector has been selected' do
      it 'is valid' do
        expect(choose_sector.valid?).to be true
      end
    end
  end

  describe '.sectors' do
    it 'returns the sectors sorted by name' do
      expect(choose_sector.sectors.map(&:name)).to eq ['Blue Light', 'Central Government', 'Devolved Admin', 'Education', 'Health', 'Local Authority']
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::ContractCost' do
      expect(choose_sector.next_step_class).to be FacilitiesManagement::RM6232::Journey::ContractCost
    end
  end

  describe '.permit_list' do
    it 'returns a list of the permitted attributes' do
      expect(described_class.permit_list).to eq [:sector_code, :contract_cost, {}]
    end
  end

  describe '.permitted_keys' do
    it 'returns a list of the permitted keys' do
      expect(described_class.permitted_keys).to eq %i[sector_code contract_cost]
    end
  end

  describe '.slug' do
    it 'returns choose-sector' do
      expect(choose_sector.slug).to eq 'choose-sector'
    end
  end

  describe '.template' do
    it 'returns journey/choose_sector' do
      expect(choose_sector.template).to eq 'journey/choose_sector'
    end
  end

  describe '.final?' do
    it 'returns false' do
      expect(choose_sector.final?).to be false
    end
  end
end
