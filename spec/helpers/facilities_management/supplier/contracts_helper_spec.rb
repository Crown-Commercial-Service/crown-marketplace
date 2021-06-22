require 'rails_helper'

RSpec.describe FacilitiesManagement::Supplier::ContractsHelper, type: :helper do
  describe '.supplier_contract_reason_id' do
    subject(:result) { helper.supplier_contract_reason_id(state) }

    context 'when the state is sent' do
      let(:state) { 'sent' }

      it 'returns no-reason-required' do
        expect(result).to eq 'no-reason-required'
      end
    end

    context 'when the state is accepted' do
      let(:state) { 'accepted' }

      it 'returns no-reason-required' do
        expect(result).to eq 'no-reason-required'
      end
    end

    context 'when the state is signed' do
      let(:state) { 'signed' }

      it 'returns no-reason-required' do
        expect(result).to eq 'no-reason-required'
      end
    end

    context 'when the state is not_signed' do
      let(:state) { 'not_signed' }

      it 'returns reason-for-not-signing' do
        expect(result).to eq 'reason-for-not-signing'
      end
    end

    context 'when the state is declined' do
      let(:state) { 'declined' }

      it 'returns reason-for-declining' do
        expect(result).to eq 'reason-for-declining'
      end
    end

    context 'when the state is withdrawn' do
      let(:state) { 'withdrawn' }

      it 'returns reason-for-closing' do
        expect(result).to eq 'reason-for-closing'
      end
    end

    context 'when the state is expired' do
      let(:state) { 'expired' }

      it 'returns no-reason-required' do
        expect(result).to eq 'no-reason-required'
      end
    end
  end
end
