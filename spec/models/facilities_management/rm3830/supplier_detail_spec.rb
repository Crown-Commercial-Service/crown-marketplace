require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::SupplierDetail do
  describe '.selected_suppliers' do
    let(:lot) { '1a' }

    before do
      [
        { lot => { regions: %w[r0 r1], services: %w[s0 s1] } },
        { lot => { regions: %w[r0 r2], services: %w[s0 s2] } },
        { lot => { regions: %w[r0 r3], services: %w[s0 s3] } }
      ].each do |lot_data|
        create(:facilities_management_rm3830_supplier_detail, lot_data: lot_data)
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

  describe '.supplier_count' do
    let(:supplier_count) { described_class.supplier_count(region_codes, service_codes) }
    let(:service_codes) { ['G.1', 'G.2', 'G.3', 'G.4'] }
    let(:region_codes) { ['UKC1', 'UKC2'] }

    context 'when there are some region codes and service codes' do
      it 'returns the correct supplier count' do
        expect(supplier_count).to eq 38
      end
    end

    context 'when there are fake region codes' do
      let(:region_codes) { ['UKP45'] }

      it 'returns the correct supplier count' do
        expect(supplier_count).to eq 0
      end
    end

    context 'when there are are fake service codes' do
      let(:service_codes) { ['Q.1'] }

      it 'returns the correct supplier count' do
        expect(supplier_count).to eq 0
      end
    end
  end

  describe '.full_organisation_address' do
    let(:full_organisation_address) { described_class.find('ef44b65d-de46-4297-8d2c-2c6130cecafc').full_organisation_address }

    it 'returns the full address with no comma before the postcode' do
      expect(full_organisation_address).to eq 'St. Helens Delivery Office, 23 Liverpool Road, St Helens WA10 1AA'
    end
  end
end
