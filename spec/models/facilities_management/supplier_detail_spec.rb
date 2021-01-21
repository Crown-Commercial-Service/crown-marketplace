require 'rails_helper'

RSpec.describe FacilitiesManagement::SupplierDetail, type: :model do
  describe '.selected_suppliers' do
    let(:lot) { '1a' }

    before do
      [
        { lot => { regions: %w[r0 r1], services: %w[s0 s1] } },
        { lot => { regions: %w[r0 r2], services: %w[s0 s2] } },
        { lot => { regions: %w[r0 r3], services: %w[s0 s3] } }
      ].each do |lot_data|
        FactoryBot.create(:facilities_management_supplier_detail, lot_data: lot_data)
      end
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'selects suppliers containing ALL specified regions and services' do
      expect(described_class.selected_suppliers(lot, %w[r0], %w[s0]).count).to eq 3

      expect(described_class.selected_suppliers(lot, %w[r0], %w[s0 s1]).count).to eq 1
      expect(described_class.selected_suppliers(lot, %w[r0], %w[s0 s2]).count).to eq 1
      expect(described_class.selected_suppliers(lot, %w[r0], %w[s4]).count).to eq 0

      expect(described_class.selected_suppliers(lot, %w[r0 r1], %w[s0]).count).to eq 1
      expect(described_class.selected_suppliers(lot, %w[r0 r2], %w[s0]).count).to eq 1
      expect(described_class.selected_suppliers(lot, %w[r4], %w[s0]).count).to eq 0
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
