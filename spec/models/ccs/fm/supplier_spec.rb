require 'rails_helper'

RSpec.describe CCS::FM::Supplier, type: :model do
  describe '.selected_suppliers' do
    let(:lot) { '1a' }

    before do
      [
        { lots: [{ lot_number: lot, regions: %w[r0 r1 r2], services: %w[s0 s1 s2] }] },
        { lots: [{ lot_number: lot, regions: %w[r0 r3 r4], services: %w[s0 s3 s4] }] },
        { lots: [{ lot_number: lot, regions: %w[r0 r5 r6], services: %w[s0 s5 s6] }] }
      ].each do |data|
        FactoryBot.create(:ccs_fm_supplier, data: data)
      end
    end

    it 'selects suppliers containing ANY specified regions' do
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s0]).count).to eq 3
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r1 r3], %w[s0]).count).to eq 2
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r5], %w[s0]).count).to eq 1
    end

    it 'selects suppliers containing ANY specified services' do
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s0]).count).to eq 3
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s1 s3]).count).to eq 2
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s5]).count).to eq 1
    end

    it 'selects suppliers where BOTH region and service selections overlap' do
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r0], %w[s1]).count).to eq 1
      expect(CCS::FM::Supplier.selected_suppliers(lot, %w[r1], %w[s0]).count).to eq 1
    end
  end
end
