require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Supplier::LotData, type: :model do
  let(:lot_data) { described_class.where(facilities_management_rm6232_supplier_id: supplier_id).find_by(lot_number: lot_number) }
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

    context 'when the supplier does all the services for a lot' do
      let(:supplier_id) { 'e72a09a3-345a-4964-8ea6-32b7a64bb5c3' }
      let(:lot_number) { '1d' }

      it 'returns the services' do
        expect(result).to eq %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.9 E.10 E.11 E.12 E.13 E.14 E.15 E.16 E.17 E.18 E.19 E.20 E.21 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 F.11 F.12 F.13 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.8 H.9 H.10 I.1 I.2 I.3 I.4 I.5 I.6 I.7 I.8 I.9 I.10 I.11 I.12 I.13 I.14 I.15 I.16 I.17 I.18 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 J.13 J.14 J.15 J.16 K.1 K.2 K.3 K.4 K.5 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 L.12 L.13 L.14 L.15 M.1 M.2 M.3 M.4 M.5 M.6 M.7 M.8 N.1 N.2 N.3 N.4 N.5 N.6 N.7 N.8 N.9 N.10 N.11 N.12 N.13 N.14 O.1 O.2 O.3 O.4 O.5 P.2 Q.1 R.1]
      end
    end

    context 'when a supplier does some services for a lot' do
      let(:supplier_id) { '1cbabae1-4be0-4091-845a-3d1a728de8e3' }
      let(:lot_number) { '2b' }

      it 'returns the services' do
        expect(result).to eq %w[E.9 E.10 E.11 E.15 E.16 E.17 E.18 E.19 F.1 F.3 F.6 F.7 F.9 F.11 F.13 G.3 G.4 G.5 G.6 G.7 G.8 N.10 P.2 Q.1 R.1]
      end
    end
  end

  describe '.regions' do
    let(:result) { lot_data.regions.map(&:code) }

    it 'returns a collection of regions' do
      expect(random_lot_data.regions.first.class).to eq FacilitiesManagement::Region
    end

    context 'when the supplier does all the regions for a lot' do
      let(:supplier_id) { 'cba705a0-6812-415a-9f6a-94bd227a3efe' }
      let(:lot_number) { '2c' }

      it 'returns the regions' do
        expect(result).to eq %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05]
      end
    end

    context 'when a supplier does some regions for a lot' do
      let(:supplier_id) { '6b91498f-3fd7-4f91-be9a-651c4e86ebed' }
      let(:lot_number) { '2b' }

      it 'returns the regions' do
        expect(result).to eq %w[UKC1 UKD6 UKD7 UKE3 UKE4 UKF1 UKG1 UKH3 UKI3 UKI5 UKJ2 UKK3 UKK4 UKL13 UKL14 UKL15 UKL16 UKL18 UKL24 UKM21 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM33 UKM34 UKM37 UKM50 UKM65 UKN01 UKN03 UKN05]
      end
    end
  end

  describe '.sectors' do
    let(:result) { lot_data.sectors.map(&:id) }

    it 'returns a collection of sectors' do
      expect(random_lot_data.sectors.class.to_s).to eq 'FacilitiesManagement::RM6232::Sector::ActiveRecord_Relation'
    end

    context 'when the supplier does all the sectors for a lot' do
      let(:supplier_id) { 'e72a09a3-345a-4964-8ea6-32b7a64bb5c3' }
      let(:lot_number) { '1d' }

      it 'returns the sectors' do
        expect(result).to eq [1, 2, 3, 4, 5, 6]
      end
    end

    context 'when a supplier does some sectors for a lot' do
      let(:supplier_id) { '9f860cdb-07ce-4cd8-aebe-bad73f70590a' }
      let(:lot_number) { '2a' }

      it 'returns the sectors' do
        expect(result).to eq [1, 3, 5, 6]
      end
    end
  end
end
