require 'rails_helper'

RSpec.describe FacilitiesManagement::Lot, type: :model do
  subject(:lots) { described_class.all }

  let(:first_lot) { lots.first }
  let(:all_numbers) { described_class.all_numbers }

  it 'loads lots from CSV' do
    expect(lots.count).to eq(3)
  end

  it 'populates attributes of first lot' do
    expect(first_lot.number).to eq('1a')
    expect(first_lot.description).to eq('Total contract value up to £7M')
  end

  it 'only has unique numbers' do
    expect(all_numbers.uniq).to contain_exactly(*all_numbers)
  end

  it 'all have descriptions' do
    expect(lots.select { |l| l.description.blank? }).to be_empty
  end

  describe '#direct_award_possible?' do
    let(:result) { lot.direct_award_possible? }

    context 'when number is 1a' do
      let(:lot) { described_class.find_by(number: '1a') }

      it 'returns truth-y' do
        expect(result).to be_truthy
      end
    end

    context 'when number is not 1a' do
      let(:lot) { described_class.find_by(number: '1b') }

      it 'returns false-y' do
        expect(result).to be_falsey
      end
    end
  end

  describe '.all_numbers' do
    it 'returns numbers for all lots' do
      expect(all_numbers.count).to eq(lots.count)
      expect(all_numbers.first).to eq(first_lot.number)
    end
  end
end
