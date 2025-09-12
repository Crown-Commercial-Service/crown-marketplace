require 'rails_helper'

RSpec.describe Position do
  describe 'associations' do
    let(:position) { create(:position) }

    it { is_expected.to belong_to(:lot) }
    it { is_expected.to have_many(:supplier_framework_lot_rates) }

    it 'has the lot relationship' do
      expect(position.lot).to be_present
    end
  end
end
