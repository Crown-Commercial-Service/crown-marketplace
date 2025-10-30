require 'rails_helper'

RSpec.describe Procurement do
  describe 'associations' do
    let(:procurement) { create(:procurement) }

    it 'has the user relationship' do
      expect(procurement.user).to be_present
    end

    it 'has the framework relationship' do
      expect(procurement.framework).to be_present
    end

    it 'has the lot relationship' do
      expect(procurement.lot).to be_present
    end
  end

  describe 'validations' do
    describe 'contract_name' do
      let(:procurement) { build(:procurement, user:, framework:) }
      let(:user) { create(:user) }
      let(:framework) { create(:framework) }

      before { procurement.contract_name = contract_name }

      context 'when the name is more than 100 characters' do
        let(:contract_name) { (0...101).map { ('a'..'z').to_a.sample }.join }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Your contract name must be 100 characters or fewer'
        end
      end

      context 'when the name is nil' do
        let(:contract_name) { nil }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is empty' do
        let(:contract_name) { '' }

        it 'is expected to not be valid and has the correct error message' do
          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'Enter your contract name'
        end
      end

      context 'when the name is taken by the same user' do
        let(:contract_name) { 'My taken name' }

        it 'is expected to not be valid and has the correct error message' do
          create(:procurement, user:, framework:, contract_name:)

          expect(procurement.valid?(:contract_name)).to be false
          expect(procurement.errors[:contract_name].first).to eq 'This contract name is already in use'
        end
      end

      context 'when the name is in use on a different frameworks' do
        let(:contract_name) { 'My taken name' }

        it 'is valid' do
          create(:procurement, user: user, framework: create(:framework), contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to be true
        end
      end

      context 'when the name is taken by the a different user' do
        let(:contract_name) { 'My taken name' }

        it 'is valid' do
          create(:procurement, user: create(:user), framework: framework, contract_name: contract_name)

          expect(procurement.valid?(:contract_name)).to be true
        end
      end

      context 'when the name is correct' do
        let(:contract_name) { 'Valid Name' }

        it 'expected to be valid' do
          expect(procurement.valid?(:contract_name)).to be true
        end
      end
    end
  end
end
