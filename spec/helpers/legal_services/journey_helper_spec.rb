require 'rails_helper'

RSpec.describe LegalServices::JourneyHelper, type: :helper do
  let(:lot_number) { rand(1..4).to_s }
  let(:lot) { LegalServices::Lot.find_by(number: lot_number) }

  describe '#lot_full_description' do
    it 'returns the full title with lot and description' do
      expect(helper.lot_full_description(lot)).to eq("Lot #{lot_number} - #{lot.description}")
    end
  end

  describe '#lot_legal_services' do
    it 'returns text containing the correct lot number' do
      expect(helper.lot_legal_services(lot)).to eq("Lot #{lot_number} legal services")
    end
  end

  describe '#region_name' do
    context 'when region is in England' do
      it 'returns the region name without England in brackets' do
        expect(helper.region_name('South West (England)')).to eq('South West')
      end
    end

    context 'when region is not in England' do
      it 'returns the region name' do
        expect(helper.region_name('Scotland')).to eq('Scotland')
      end
    end
  end
end
