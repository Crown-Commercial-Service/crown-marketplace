require 'rails_helper'

RSpec.describe Service do
  describe 'associations' do
    let(:service) { create(:service) }

    it { is_expected.to belong_to(:lot) }
    it { is_expected.to have_many(:supplier_framework_lot_services) }

    it 'has the lot relationship' do
      expect(service.lot).to be_present
    end
  end
end
