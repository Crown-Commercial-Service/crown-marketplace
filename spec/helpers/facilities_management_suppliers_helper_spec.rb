require 'rails_helper'

RSpec.describe FacilitiesManagementSuppliersHelper, type: :helper do
  describe '#contract_value_range_text' do
    let(:text) { helper.contract_value_range_text(lot_number) }

    context 'when lot_number is 1a' do
      let(:lot_number) { '1a' }

      it 'returns contract value range text for the lot number' do
        expect(text).to eq('Total contract value up to £7M')
      end
    end

    context 'when lot_number is 1b' do
      let(:lot_number) { '1b' }

      it 'returns contract value range text for the lot number' do
        expect(text).to eq('Total contract value £7M - £50M')
      end
    end

    context 'when lot_number is 1c' do
      let(:lot_number) { '1c' }

      it 'returns contract value range text for the lot number' do
        expect(text).to eq('Total contract value over £50M')
      end
    end
  end
end
