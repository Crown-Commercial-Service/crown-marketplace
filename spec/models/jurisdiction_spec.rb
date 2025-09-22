require 'rails_helper'

RSpec.describe Jurisdiction do
  describe 'associations' do
    let(:jurisdiction) { described_class.first }

    it { is_expected.to have_many(:supplier_framework_lot_jurisdictions) }
  end

  it 'has all the jurisdictions loaded' do
    expect(described_class.count).to eq(322)
  end

  describe 'scopes' do
    it 'has 8 jurisdictions for the core scope' do
      expect(described_class.core.count).to eq(8)
    end

    it 'has 240 jurisdictions for the non_core scope' do
      expect(described_class.non_core.count).to eq(240)
    end
  end
end
