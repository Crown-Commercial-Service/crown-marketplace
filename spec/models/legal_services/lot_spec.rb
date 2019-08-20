require 'rails_helper'

RSpec.describe LegalServices::Lot, type: :model do
  subject(:lots) { described_class.all }

  let(:first_lot) { lots.first }
  let(:all_numbers) { described_class.all_numbers }
  let(:sublot_numbers) { described_class.sublot_numbers }

  it 'loads lots from CSV' do
    expect(lots.count).to eq(4)
  end

  it 'populates attributes of first lot' do
    expect(first_lot.number).to eq('1')
    expect(first_lot.description).to eq('Regional service provision')
  end

  it 'only has unique numbers' do
    expect(all_numbers.uniq).to contain_exactly(*all_numbers)
  end

  it 'all have descriptions' do
    expect(lots.select { |l| l.description.blank? }).to be_empty
  end

  describe '.[]' do
    it 'looks up lot by number' do
      expect(described_class['1'].number).to eq('1')
    end
  end

  describe '.all_numbers' do
    it 'returns numbers for all lots and sublots' do
      expect(all_numbers.count).to eq(lots.count + sublot_numbers.count)
      expect(all_numbers.first).to eq(first_lot.number)
    end
  end

  describe '.sublot_numbers' do
    it 'returns the sublot numbers' do
      expect(sublot_numbers.count).to eq(3)
    end
  end
end
