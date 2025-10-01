require 'rails_helper'

RSpec.describe Jurisdiction do
  describe 'associations' do
    let(:jurisdiction) { described_class.first }

    it { is_expected.to have_many(:supplier_framework_lot_jurisdictions) }
  end

  it 'has all the jurisdictions loaded' do
    expect(described_class.count).to eq(327)
  end

  describe 'scopes' do
    it 'has 8 jurisdictions for the core scope' do
      expect(described_class.core.count).to eq(8)
    end

    it 'has 240 jurisdictions for the non_core scope' do
      expect(described_class.non_core.count).to eq(240)
    end
  end

  describe 'ordered_by_category_and_number scope' do
    it 'returns the servies sorted by category then number' do
      expect(described_class.where(id: ['TLD3', 'TLD1', 'TLN0D', 'TLN0A', 'TLN06', 'TLG2']).ordered_by_category_and_number.pluck(:id)).to eq(['TLD1', 'TLD3', 'TLG2', 'TLN06', 'TLN0A', 'TLN0D'])
    end
  end
end
