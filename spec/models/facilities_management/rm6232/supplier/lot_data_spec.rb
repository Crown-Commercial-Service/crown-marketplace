require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Supplier::LotData, type: :model do
  let(:lot_data) { described_class.where(facilities_management_rm6232_supplier_id: supplier_id).find_by(lot_code: lot_code) }
  let(:random_lot_data) { described_class.order(Arel.sql('RANDOM()')).first }

  describe '.supplier_name' do
    it 'returns the suppleirs name from the supplier model' do
      supplier_name = FacilitiesManagement::RM6232::Supplier.find(random_lot_data.facilities_management_rm6232_supplier_id).supplier_name

      expect(random_lot_data.supplier_name).to eq supplier_name
    end
  end

  describe '.services' do
    let(:result) { lot_data.services.map(&:code) }

    it 'returns a collection of services' do
      expect(random_lot_data.services.class.to_s).to eq 'FacilitiesManagement::RM6232::Service::ActiveRecord_Relation'
    end

    it 'has all the core services' do
      core_services = %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.10 E.11 E.12 E.13 F.1 F.2 F.3 F.7 F.8 F.10 F.11 F.13 G.1 G.2 G.4 G.5 H.2 H.3 H.5 H.9 I.1 I.2 I.5 I.6 I.7 I.8 I.16 J.1 J.2 J.3 J.4 J.6 J.13 K.1 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.11 L.13 L.15 M.1 M.2 M.3 M.8 Q.1 Q.2 R.1 S.1]

      expect(core_services - random_lot_data.service_codes).to be_empty
    end
  end

  describe '.regions' do
    let(:result) { lot_data.regions.map(&:code) }

    it 'returns a collection of regions' do
      expect(random_lot_data.regions.first.class).to eq FacilitiesManagement::Region
    end

    it 'has at least one reagion' do
      expect(random_lot_data.region_codes.count).to be >= 1
    end
  end

  describe 'validations' do
    context 'when validating the region codes' do
      let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, :with_supplier, region_codes: region_codes) }

      context 'and there are none' do
        let(:region_codes) { [] }

        it 'is not valid and has the correct error message' do
          expect(lot_data.valid?(:region_codes)).to be false
          expect(lot_data.errors[:region_codes].first).to eq 'You must select at least one region for this lot'
        end
      end

      context 'and there are some' do
        let(:region_codes) { %w[UKC1 UKC2] }

        it 'is valid' do
          expect(lot_data.valid?(:region_codes)).to be true
        end
      end
    end
  end
end
