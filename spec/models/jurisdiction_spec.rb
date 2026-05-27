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

  describe 'regions_grouped_by_category' do
    let(:result) { described_class.regions_grouped_by_category.map { |category, regions| [category, regions.length] } }

    # rubocop:disable RSpec/ExampleLength
    it 'services are grouped together as expected' do
      expect(result).to eq(
        [
          ['TLC', 2],
          ['TLD', 5],
          ['TLE', 4],
          ['TLF', 3],
          ['TLG', 3],
          ['TLH', 5],
          ['TLI', 5],
          ['TLJ', 4],
          ['TLK', 5],
          ['TLL', 12],
          ['TLM', 18],
          ['TLN', 11],
          ['NC0', 1],
          ['OS0', 1]
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
