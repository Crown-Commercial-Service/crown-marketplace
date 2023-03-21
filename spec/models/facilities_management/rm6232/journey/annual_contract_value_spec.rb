require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::AnnualContractValue do
  let(:annual_contract_value) { described_class.new(annual_contract_value: estimated_annual_contract_value) }
  let(:estimated_annual_contract_value) { 123_456 }

  describe 'validations' do
    context 'when no annual contract cost is present' do
      let(:estimated_annual_contract_value) { nil }

      it 'is not valid and has the correct error message' do
        expect(annual_contract_value.valid?).to be false
        expect(annual_contract_value.errors[:annual_contract_value].first).to eq 'The annual contract cost must be a whole number greater than 0'
      end
    end

    context 'when the annual contract cost is not a number' do
      let(:estimated_annual_contract_value) { 'Morag' }

      it 'is not valid and has the correct error message' do
        expect(annual_contract_value.valid?).to be false
        expect(annual_contract_value.errors[:annual_contract_value].first).to eq 'The annual contract cost must be a whole number greater than 0'
      end
    end

    context 'when the annual contract cost is not an integer' do
      let(:estimated_annual_contract_value) { 1_000_000.67 }

      it 'is not valid and has the correct error message' do
        expect(annual_contract_value.valid?).to be false
        expect(annual_contract_value.errors[:annual_contract_value].first).to eq 'The annual contract cost must be a whole number greater than 0'
      end
    end

    context 'when the annual contract cost is less than 1' do
      let(:estimated_annual_contract_value) { 0 }

      it 'is not valid and has the correct error message' do
        expect(annual_contract_value.valid?).to be false
        expect(annual_contract_value.errors[:annual_contract_value].first).to eq 'The annual contract cost must be a whole number greater than 0'
      end
    end

    context 'when the annual contract cost is more than 999,999,999,999' do
      let(:estimated_annual_contract_value) { 1_000_000_000_000 }

      it 'is not valid and has the correct error message' do
        expect(annual_contract_value.valid?).to be false
        expect(annual_contract_value.errors[:annual_contract_value].first).to eq 'The annual contract cost must be less than 1,000,000,000,000 (1 trillion)'
      end
    end

    context 'when annual contract cost is present' do
      it 'is valid' do
        expect(annual_contract_value.valid?).to be true
      end
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::Procurement' do
      expect(annual_contract_value.next_step_class).to be FacilitiesManagement::RM6232::Journey::Procurement
    end
  end

  describe '.permit_list' do
    it 'returns a list of the permitted attributes' do
      expect(described_class.permit_list).to eq [:annual_contract_value, {}]
    end
  end

  describe '.permitted_keys' do
    it 'returns a list of the permitted keys' do
      expect(described_class.permitted_keys).to eq %i[annual_contract_value]
    end
  end

  describe '.slug' do
    it 'returns annual-contract-value' do
      expect(annual_contract_value.slug).to eq 'annual-contract-value'
    end
  end

  describe '.template' do
    it 'returns journey/annual_contract_value' do
      expect(annual_contract_value.template).to eq 'journey/annual_contract_value'
    end
  end

  describe '.final?' do
    it 'returns false' do
      expect(annual_contract_value.final?).to be false
    end
  end
end
