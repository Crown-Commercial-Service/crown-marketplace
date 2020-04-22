require 'rails_helper'

RSpec.describe CCS::FM::Supplier, type: :model do
  describe '.selected_suppliers' do
    let(:lot) { '1a' }

    before do
      [
        { lots: [{ lot_number: lot, regions: %w[r0 r1], services: %w[s0 s1] }] },
        { lots: [{ lot_number: lot, regions: %w[r0 r2], services: %w[s0 s2] }] },
        { lots: [{ lot_number: lot, regions: %w[r0 r3], services: %w[s0 s3] }] }
      ].each do |data|
        FactoryBot.create(:ccs_fm_supplier, data: data)
      end
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'selects suppliers containing ALL specified regions and services' do
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s0]).count).to eq 3

      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s0 s1]).count).to eq 1
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s0 s2]).count).to eq 1
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s4]).count).to eq 0

      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0 r1], %w[s0]).count).to eq 1
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0 r2], %w[s0]).count).to eq 1
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r4], %w[s0]).count).to eq 0
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
