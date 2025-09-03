require 'rails_helper'

RSpec.describe Position do
  describe 'associations' do
    let(:position) { described_class.first }

    it { is_expected.to have_many(:supplier_framework_lot_rates) }
  end

  it 'has all the positions loaded' do
    expect(described_class.count).to eq(60)
  end
end
