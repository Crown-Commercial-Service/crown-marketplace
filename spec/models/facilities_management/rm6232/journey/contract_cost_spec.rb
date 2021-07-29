require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Journey::ContractCost, type: :model do
  let(:contract_cost) { described_class.new(contract_cost: etimated_contract_cost) }
  let(:etimated_contract_cost) { 123_456 }

  describe 'validations' do
    context 'when no contract cost is present' do
      let(:etimated_contract_cost) { nil }

      it 'is not valid and has the correct error message' do
        expect(contract_cost.valid?).to be false
        expect(contract_cost.errors[:contract_cost].first).to eq 'The estimated contract cost must be a number between 1 and 999,999,999'
      end
    end

    context 'when the contract cost is not a number' do
      let(:etimated_contract_cost) { 'Morag' }

      it 'is not valid and has the correct error message' do
        expect(contract_cost.valid?).to be false
        expect(contract_cost.errors[:contract_cost].first).to eq 'The estimated contract cost must be a number between 1 and 999,999,999'
      end
    end

    context 'when the contract cost is not an integer' do
      let(:etimated_contract_cost) { 1_000_000.67 }

      it 'is not valid and has the correct error message' do
        expect(contract_cost.valid?).to be false
        expect(contract_cost.errors[:contract_cost].first).to eq 'The estimated contract cost must be a number between 1 and 999,999,999'
      end
    end

    context 'when the contract cost is less than 1' do
      let(:etimated_contract_cost) { 0 }

      it 'is not valid and has the correct error message' do
        expect(contract_cost.valid?).to be false
        expect(contract_cost.errors[:contract_cost].first).to eq 'The estimated contract cost must be a number between 1 and 999,999,999'
      end
    end

    context 'when the contract cost is more than 999,999,999' do
      let(:etimated_contract_cost) { 1_000_000_000 }

      it 'is not valid and has the correct error message' do
        expect(contract_cost.valid?).to be false
        expect(contract_cost.errors[:contract_cost].first).to eq 'The estimated contract cost must be a number between 1 and 999,999,999'
      end
    end

    context 'when contract cost is present' do
      it 'is valid' do
        expect(contract_cost.valid?).to be true
      end
    end
  end

  describe '.next_step_class' do
    it 'returns Journey::Procurement' do
      expect(contract_cost.next_step_class).to be FacilitiesManagement::RM6232::Journey::Procurement
    end
  end

  describe '.permit_list' do
    it 'returns a list of the permitted attributes' do
      expect(described_class.permit_list).to eq [:contract_cost, {}]
    end
  end

  describe '.permitted_keys' do
    it 'returns a list of the permitted keys' do
      expect(described_class.permitted_keys).to eq %i[contract_cost]
    end
  end

  describe '.slug' do
    it 'returns contract-cost' do
      expect(contract_cost.slug).to eq 'contract-cost'
    end
  end

  describe '.template' do
    it 'returns journey/contract_cost' do
      expect(contract_cost.template).to eq 'journey/contract_cost'
    end
  end

  describe '.final?' do
    it 'returns false' do
      expect(contract_cost.final?).to be false
    end
  end
end
