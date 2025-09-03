require 'rails_helper'

RSpec.describe Jurisdiction do
  describe 'associations' do
    let(:jurisdiction) { described_class.first }

    it { is_expected.to have_many(:supplier_framework_lot_jurisdictions) }
  end

  it 'has all the jurisdictions loaded' do
    expect(described_class.count).to eq(248)
  end
end
