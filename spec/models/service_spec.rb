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

  describe 'ordered_by_category_and_number scope' do
    it 'returns the servies sorted by category then number' do
      expect(described_class.where(id: ['RM6378.1a.C1', 'RM6378.1a.C2', 'RM6378.1a.E5', 'RM6378.1a.E3', 'RM6378.1a.D1', 'RM6378.1a.G10', 'RM6378.1a.G1', 'RM6378.1a.G12']).ordered_by_category_and_number.pluck(:id)).to eq(['RM6378.1a.C1', 'RM6378.1a.C2', 'RM6378.1a.D1', 'RM6378.1a.E3', 'RM6378.1a.E5', 'RM6378.1a.G1', 'RM6378.1a.G10', 'RM6378.1a.G12'])    end
  end
end
