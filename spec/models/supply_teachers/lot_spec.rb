require 'rails_helper'

RSpec.describe SupplyTeachers::Lot, type: :model do
  subject(:lots) { described_class.all }

  let(:first_lot) { lots.first }

  it 'loads lots from CSV' do
    expect(lots.count).to eq(3)
  end

  it 'populates attributes of first lot' do
    expect(first_lot.number).to eq('1')
    expect(first_lot.description).to eq('Direct provision')
  end

  describe '.all_numbers' do
    it 'returns numbers for all lots' do
      expect(described_class.all_numbers.count).to eq(lots.count)
      expect(described_class.all_numbers.first).to eq(first_lot.number.to_i)
    end
  end
end
