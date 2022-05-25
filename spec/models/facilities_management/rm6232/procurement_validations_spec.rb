require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Procurement, type: :model do
  describe 'validations' do
    describe 'contract_name' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_what_happens_next, user: user) }
      let(:user) { create(:user) }

      before { procurement.contract_name = contract_name }

      context 'when the name is more than 100 characters' do
        let(:contract_name) { (0...101).map { ('a'..'z').to_a.sample }.join }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to eq false
          expect(procurement.errors[:contract_name].first).to eq 'Your contract name must be 100 characters or fewer'
        end
      end

      context 'when the name is nil' do
        let(:contract_name) { nil }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to eq false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is empty' do
        let(:contract_name) { '' }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to eq false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is taken by the same user' do
        let(:contract_name) { 'My taken name' }

        it 'is expected to not be valid and has the correct error message' do
          create(:facilities_management_rm6232_procurement_what_happens_next, user: user, contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to eq false
          expect(procurement.errors[:contract_name].first).to eq 'This contract name is already in use'
        end
      end

      context 'when the name is taken by the a different user' do
        let(:contract_name) { 'My taken name' }

        it 'is valid' do
          create(:facilities_management_rm6232_procurement_what_happens_next, user: create(:user), contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to eq true
        end
      end

      context 'when the name is correct' do
        let(:contract_name) { 'Valid Name' }

        it 'expected to be valid' do
          expect(procurement.valid?(:contract_name)).to eq true
        end
      end
    end

    describe 'annual_contract_value' do
      let(:procurement) { build(:facilities_management_rm6232_procurement_entering_requirements, annual_contract_value: annual_contract_value) }

      context 'when no annual contract value is present' do
        let(:annual_contract_value) { nil }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract value must be a whole number greater than 0'
        end
      end

      context 'when the annual contract value is not a number' do
        let(:annual_contract_value) { 'Camuvari' }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract value must be a whole number greater than 0'
        end
      end

      context 'when the annual contract value is not an integer' do
        let(:annual_contract_value) { 1_000_000.67 }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract value must be a whole number greater than 0'
        end
      end

      context 'when the annual contract value is less than 1' do
        let(:annual_contract_value) { 0 }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract value must be a whole number greater than 0'
        end
      end

      context 'when the annual contract value is more than 999,999,999,999' do
        let(:annual_contract_value) { 1_000_000_000_000 }

        it 'is not valid and has the correct error message' do
          expect(procurement.valid?(:annual_contract_value)).to be false
          expect(procurement.errors[:annual_contract_value].first).to eq 'The annual contract value must be less than 1,000,000,000,000 (1 trillion)'
        end
      end

      context 'when annual contract value is present' do
        let(:annual_contract_value) { 123_456 }

        it 'is valid' do
          expect(procurement.valid?(:annual_contract_value)).to be true
        end
      end
    end
  end
end
