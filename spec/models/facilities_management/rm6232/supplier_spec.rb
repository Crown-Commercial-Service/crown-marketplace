require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Supplier, type: :model do
  describe '.lot_data' do
    context 'when selecting a random supplier' do
      let(:supplier) { described_class.order(Arel.sql('RANDOM()')).first }

      it 'has lot data' do
        expect(supplier.lot_data.class.to_s).to eq 'FacilitiesManagement::RM6232::Supplier::LotData::ActiveRecord_Associations_CollectionProxy'
      end
    end

    context 'when selecting a specific supplier' do
      let(:supplier_lot_data) { described_class.find('556a281f-b166-47da-9f5e-37adc8d0a6a0').lot_data }
      let(:lot_data) { supplier_lot_data.find_by(lot_number: lot_number) }

      it 'has the correct lots' do
        expect(supplier_lot_data.pluck(:lot_number)).to match %w[1d 2c 3c]
      end

      context 'when the lot is 1a' do
        let(:lot_number) { '1d' }

        it 'has all the services, regions and sectors' do
          expect(lot_data.service_codes.count).to eq 70
          expect(lot_data.region_codes.count).to eq 35
          expect(lot_data.sector_codes.count).to eq 4
        end
      end

      context 'when the lot is 2c' do
        let(:lot_number) { '2c' }

        it 'has all the services, regions and sectors' do
          expect(lot_data.service_codes.count).to eq 25
          expect(lot_data.region_codes.count).to eq 35
          expect(lot_data.sector_codes.count).to eq 4
        end
      end

      context 'when the lot is 3c' do
        let(:lot_number) { '3c' }

        it 'has all the services, regions and sectors' do
          expect(lot_data.service_codes.count).to eq 49
          expect(lot_data.region_codes.count).to eq 35
          expect(lot_data.sector_codes.count).to eq 4
        end
      end
    end
  end

  describe '.select_suppliers' do
    let(:result) { described_class.select_suppliers(lot_number, service_codes, region_codes, sector_code) }
    let(:supplier_names) { result.map(&:supplier_name) }

    context 'when all the inputs are nil' do
      let(:lot_number) { nil }
      let(:service_codes) { [] }
      let(:region_codes) { [] }
      let(:sector_code) { nil }

      it 'returns nothing' do
        expect(result).to be_empty
      end
    end

    context 'when the lot number is 1a' do
      let(:lot_number) { '1a' }

      context 'when everything is selected' do
        let(:service_codes) { %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.9 E.10 E.11 E.12 E.13 E.14 E.15 E.16 E.17 E.18 E.19 E.20 E.21 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 F.11 F.12 F.13 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.8 H.9 H.10 I.1 I.2 I.3 I.5 I.6 I.7 I.8 I.9 I.10 I.11 I.12 I.13 I.14 I.15 I.16 I.17 I.18 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 J.13 J.14 J.15 J.16 K.1 K.2 K.3 K.4 K.5 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 L.12 L.13 L.14 L.15 M.1 M.2 M.3 M.4 M.5 M.6 M.7 M.8 N.1 N.2 N.3 N.4 N.5 N.6 N.7 N.8 N.9 N.10 N.11 N.12 N.13 N.14 O.1 O.2 O.3 O.4 O.5 P.2 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gleason plc', 'Ondricka LLP', 'Powlowski LLP', 'Zulauf Ltd']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[E.1 E.2 G.1 G.2 H.1 H.2 N.12 Q.1] }
        let(:region_codes) { %w[UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24] }
        let(:sector_code) { 5 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end
    end

    context 'when the lot number is 1b' do
      let(:lot_number) { '1b' }

      context 'when everything is selected' do
        let(:service_codes) { %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.9 E.10 E.11 E.12 E.13 E.14 E.15 E.16 E.17 E.18 E.19 E.20 E.21 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 F.11 F.12 F.13 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.8 H.9 H.10 I.1 I.2 I.3 I.5 I.6 I.7 I.8 I.9 I.10 I.11 I.12 I.13 I.14 I.15 I.16 I.17 I.18 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 J.13 J.14 J.15 J.16 K.1 K.2 K.3 K.4 K.5 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 L.12 L.13 L.14 L.15 M.1 M.2 M.3 M.4 M.5 M.6 M.7 M.8 N.1 N.2 N.3 N.4 N.5 N.6 N.7 N.8 N.9 N.10 N.11 N.12 N.13 N.14 O.1 O.2 O.3 O.4 O.5 P.2 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gleason plc', 'Ondricka LLP', 'Powlowski LLP', 'Zulauf Ltd']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[E.1 E.2 G.1 G.2 H.1 H.2 N.12 Q.1] }
        let(:region_codes) { %w[UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24] }
        let(:sector_code) { 5 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end
    end

    context 'when the lot number is 1c' do
      let(:lot_number) { '1c' }

      context 'when everything is selected' do
        let(:service_codes) { %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.9 E.10 E.11 E.12 E.13 E.14 E.15 E.16 E.17 E.18 E.19 E.20 E.21 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 F.11 F.12 F.13 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.8 H.9 H.10 I.1 I.2 I.3 I.5 I.6 I.7 I.8 I.9 I.10 I.11 I.12 I.13 I.14 I.15 I.16 I.17 I.18 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 J.13 J.14 J.15 J.16 K.1 K.2 K.3 K.4 K.5 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 L.12 L.13 L.14 L.15 M.1 M.2 M.3 M.4 M.5 M.6 M.7 M.8 N.1 N.2 N.3 N.4 N.5 N.6 N.7 N.8 N.9 N.10 N.11 N.12 N.13 N.14 O.1 O.2 O.3 O.4 O.5 P.2 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Hettinger LLP', 'Kuvalis Ltd', 'Welch Ltd']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[E.1 E.2 G.1 G.2 H.1 H.2 N.12 Q.1] }
        let(:region_codes) { %w[UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24] }
        let(:sector_code) { 5 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Greenfelder plc', 'Hettinger LLP', 'Johnston plc', 'Kuvalis Ltd', 'McKenzie LLP', 'Schulist LLP', 'Sipes plc', 'Welch Ltd']
        end
      end
    end

    context 'when the lot number is 1d' do
      let(:lot_number) { '1d' }

      context 'when everything is selected' do
        let(:service_codes) { %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.9 E.10 E.11 E.12 E.13 E.14 E.15 E.16 E.17 E.18 E.19 E.20 E.21 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 F.11 F.12 F.13 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.8 H.9 H.10 I.1 I.2 I.3 I.5 I.6 I.7 I.8 I.9 I.10 I.11 I.12 I.13 I.14 I.15 I.16 I.17 I.18 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 J.13 J.14 J.15 J.16 K.1 K.2 K.3 K.4 K.5 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 L.12 L.13 L.14 L.15 M.1 M.2 M.3 M.4 M.5 M.6 M.7 M.8 N.1 N.2 N.3 N.4 N.5 N.6 N.7 N.8 N.9 N.10 N.11 N.12 N.13 N.14 O.1 O.2 O.3 O.4 O.5 P.2 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Watsica LLP']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[E.1 E.2 G.1 G.2 H.1 H.2 N.12 Q.1] }
        let(:region_codes) { %w[UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24] }
        let(:sector_code) { 5 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Abernathy plc', 'Feest Ltd', 'Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Rowe plc', 'Schiller plc', 'Tremblay LLP', 'Watsica LLP']
        end
      end
    end

    context 'when the lot number is 2a' do
      let(:lot_number) { '2a' }

      context 'when everything is selected' do
        let(:service_codes) { %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.9 E.10 E.11 E.12 E.13 E.14 E.15 E.16 E.17 E.18 E.19 E.20 E.21 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 F.11 F.12 F.13 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 N.10 N.12 P.2 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gleason plc', 'Ondricka LLP', 'Powlowski LLP', 'Zulauf Ltd']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[E.20 E.21 F.13 G.8 N.12 Q.1 R.1] }
        let(:region_codes) { %w[UKF1 UKF2 UKF3] }
        let(:sector_code) { 2 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end
    end

    context 'when the lot number is 2b' do
      let(:lot_number) { '2b' }

      context 'when everything is selected' do
        let(:service_codes) { %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.9 E.10 E.11 E.12 E.13 E.14 E.15 E.16 E.17 E.18 E.19 E.20 E.21 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 F.11 F.12 F.13 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 N.10 N.12 P.2 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Hettinger LLP', 'Kuvalis Ltd', 'Welch Ltd']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[E.20 E.21 F.13 G.8 N.12 Q.1 R.1] }
        let(:region_codes) { %w[UKF1 UKF2 UKF3] }
        let(:sector_code) { 2 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Greenfelder plc', 'Hettinger LLP', 'Johnston plc', 'Kuvalis Ltd', 'McKenzie LLP', 'Schulist LLP', 'Sipes plc', 'Welch Ltd']
        end
      end
    end

    context 'when the lot number is 2c' do
      let(:lot_number) { '2c' }

      context 'when everything is selected' do
        let(:service_codes) { %w[E.1 E.2 E.3 E.4 E.5 E.6 E.7 E.8 E.9 E.10 E.11 E.12 E.13 E.14 E.15 E.16 E.17 E.18 E.19 E.20 E.21 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 F.11 F.12 F.13 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 N.10 N.12 P.2 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Watsica LLP']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[E.20 E.21 F.13 G.8 N.12 Q.1 R.1] }
        let(:region_codes) { %w[UKF1 UKF2 UKF3] }
        let(:sector_code) { 2 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Abernathy plc', 'Feest Ltd', 'Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Rowe plc', 'Schiller plc', 'Tremblay LLP', 'Watsica LLP']
        end
      end
    end

    context 'when the lot number is 3a' do
      let(:lot_number) { '3a' }

      context 'when everything is selected' do
        let(:service_codes) { %w[G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.8 H.9 H.10 I.2 I.3 I.4 I.5 I.6 I.7 I.8 I.9 I.10 I.11 I.12 I.13 I.14 I.15 I.16 I.17 I.18 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 J.13 J.14 J.15 J.16 K.1 K.2 K.3 K.4 K.5 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 L.12 L.13 L.14 L.15 M.1 M.2 M.3 M.4 M.5 M.6 M.7 M.8 N.1 N.2 N.3 N.4 N.5 N.6 N.7 N.8 N.9 N.10 N.11 N.13 N.14 P.1 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gleason plc', 'Ondricka LLP', 'Powlowski LLP', 'Zulauf Ltd']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[G.1 G.2 H.1 I.4 J.1 K.2 L.4 P.1] }
        let(:region_codes) { %w[UKI3 UKI4 UKI5 UKI6 UKI7] }
        let(:sector_code) { 3 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end
    end

    context 'when the lot number is 3b' do
      let(:lot_number) { '3b' }

      context 'when everything is selected' do
        let(:service_codes) { %w[G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.8 H.9 H.10 I.2 I.3 I.4 I.5 I.6 I.7 I.8 I.9 I.10 I.11 I.12 I.13 I.14 I.15 I.16 I.17 I.18 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 J.13 J.14 J.15 J.16 K.1 K.2 K.3 K.4 K.5 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 L.12 L.13 L.14 L.15 M.1 M.2 M.3 M.4 M.5 M.6 M.7 M.8 N.1 N.2 N.3 N.4 N.5 N.6 N.7 N.8 N.9 N.10 N.11 N.13 N.14 P.1 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Hettinger LLP', 'Kuvalis Ltd', 'Welch Ltd']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[G.1 G.2 H.1 I.4 J.1 K.2 L.4 P.1] }
        let(:region_codes) { %w[UKI3 UKI4 UKI5 UKI6 UKI7] }
        let(:sector_code) { 3 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Greenfelder plc', 'Hettinger LLP', 'Johnston plc', 'Kuvalis Ltd', 'McKenzie LLP', 'Schulist LLP', 'Sipes plc', 'Welch Ltd']
        end
      end
    end

    context 'when the lot number is 3c' do
      let(:lot_number) { '3c' }

      context 'when everything is selected' do
        let(:service_codes) { %w[G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1 H.2 H.3 H.4 H.5 H.6 H.7 H.8 H.9 H.10 I.2 I.3 I.4 I.5 I.6 I.7 I.8 I.9 I.10 I.11 I.12 I.13 I.14 I.15 I.16 I.17 I.18 J.1 J.2 J.3 J.4 J.5 J.6 J.7 J.8 J.9 J.10 J.11 J.12 J.13 J.14 J.15 J.16 K.1 K.2 K.3 K.4 K.5 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 L.12 L.13 L.14 L.15 M.1 M.2 M.3 M.4 M.5 M.6 M.7 M.8 N.1 N.2 N.3 N.4 N.5 N.6 N.7 N.8 N.9 N.10 N.11 N.13 N.14 P.1 Q.1 R.1] }
        let(:region_codes) { %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1 UKG2 UKG3 UKH1 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ3 UKJ4 UKK1 UKK2 UKK3 UKK4 UKL11 UKL12 UKL13 UKL14 UKL15 UKL16 UKL17 UKL18 UKL21 UKL22 UKL23 UKL24 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32 UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50 UKM61 UKM62 UKM63 UKM64 UKM65 UKM66 UKN01 UKN02 UKN03 UKN04 UKN05] }
        let(:sector_code) { 1 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Watsica LLP']
        end
      end

      context 'when a small number of services are selected' do
        let(:service_codes) { %w[G.1 G.2 H.1 I.4 J.1 K.2 L.4 P.1] }
        let(:region_codes) { %w[UKI3 UKI4 UKI5 UKI6 UKI7] }
        let(:sector_code) { 3 }

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Abernathy plc', 'Feest Ltd', 'Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Rowe plc', 'Schiller plc', 'Tremblay LLP', 'Watsica LLP']
        end
      end
    end
  end
end
