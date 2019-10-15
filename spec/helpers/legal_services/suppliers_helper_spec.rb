require 'rails_helper'

RSpec.describe LegalServices::SuppliersHelper, type: :helper do
  let(:lot_number) { rand(1..4).to_s }
  let(:lot) { LegalServices::Lot.find_by(number: lot_number) }

  describe '#full_lot_description' do
    it 'returns the full title with lot and description' do
      expect(helper.full_lot_description(lot.number, lot.description)).to eq("Lot #{lot_number} - #{lot.description}")
    end
  end

  describe '#url_formatter' do
    context 'with a url that is missing the protocol' do
      it 'returns the url with a http protocol' do
        url = 'www.example.com'

        expect(helper.url_formatter(url)).to eq('http://www.example.com')
      end
    end

    context 'with a url that is not missing the protocol' do
      it 'returns the provided url' do
        url = 'https://www.example.com'

        expect(helper.url_formatter(url)).to eq('https://www.example.com')
      end
    end
  end
end
