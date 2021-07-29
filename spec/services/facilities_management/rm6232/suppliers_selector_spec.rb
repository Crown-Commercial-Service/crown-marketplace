require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::SuppliersSelector do
  subject(:suppliers_selector) { described_class.new(service_codes, region_codes, sector_code, contract_cost) }

  let(:lot_number) { suppliers_selector.lot_number }
  let(:supplier_names) { suppliers_selector.selected_suppliers.map(&:supplier_name) }

  describe 'lot number and selected suppliers' do
    context 'when all services are hard' do
      let(:service_codes) { %w[E.1 E.2 E.3] }
      let(:region_codes) { %w[UKC1 UKC2] }
      let(:sector_code) { 1 }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns 2a for the lot number' do
          expect(lot_number).to eq '2a'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 2b for the lot number' do
          expect(lot_number).to eq '2b'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Greenfelder plc', 'Hettinger LLP', 'Johnston plc', 'Kuvalis Ltd', 'McKenzie LLP', 'Schulist LLP', 'Sipes plc', 'Welch Ltd']
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 2c for the lot number' do
          expect(lot_number).to eq '2c'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Abernathy plc', 'Feest Ltd', 'Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Rowe plc', 'Schiller plc', 'Tremblay LLP', 'Watsica LLP']
        end
      end
    end

    context 'when all services are soft' do
      let(:service_codes) { %w[H.1 H.2 H.3]  }
      let(:region_codes) { %w[UKE1 UKE2 UKE3 UKE4] }
      let(:sector_code) { 2 }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns 3a for the lot number' do
          expect(lot_number).to eq '3a'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 3b for the lot number' do
          expect(lot_number).to eq '3b'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Greenfelder plc', 'Hettinger LLP', 'Johnston plc', 'Kuvalis Ltd', 'McKenzie LLP', 'Schulist LLP', 'Sipes plc', 'Welch Ltd']
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 3c for the lot number' do
          expect(lot_number).to eq '3c'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Abernathy plc', 'Feest Ltd', 'Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Rowe plc', 'Schiller plc', 'Tremblay LLP', 'Watsica LLP']
        end
      end
    end

    context 'when there are a mix of hard and total' do
      let(:service_codes) { %w[F.1 F.2 F.3 G.1 R.1] }
      let(:region_codes) { %w[UKD1 UKD3 UKD4 UKD6 UKD7] }
      let(:sector_code) { 3 }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns 2a for the lot number' do
          expect(lot_number).to eq '2a'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 2b for the lot number' do
          expect(lot_number).to eq '2b'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Greenfelder plc', 'Hettinger LLP', 'Johnston plc', 'Kuvalis Ltd', 'McKenzie LLP', 'Schulist LLP', 'Sipes plc', 'Welch Ltd']
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 2c for the lot number' do
          expect(lot_number).to eq '2c'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Abernathy plc', 'Feest Ltd', 'Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Rowe plc', 'Schiller plc', 'Tremblay LLP', 'Watsica LLP']
        end
      end
    end

    context 'when there are a mix of soft and total' do
      let(:service_codes) { %w[G.4 H.5 H.6 H.7 N.9 N.10 P.1] }
      let(:region_codes) { %w[UKI3 UKI4 UKI5 UKI6 UKI7] }
      let(:sector_code) { 4 }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns 3a for the lot number' do
          expect(lot_number).to eq '3a'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 3b for the lot number' do
          expect(lot_number).to eq '3b'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Greenfelder plc', 'Hettinger LLP', 'Johnston plc', 'Kuvalis Ltd', 'McKenzie LLP', 'Schulist LLP', 'Sipes plc', 'Welch Ltd']
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 3c for the lot number' do
          expect(lot_number).to eq '3c'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Abernathy plc', 'Feest Ltd', 'Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Rowe plc', 'Schiller plc', 'Tremblay LLP', 'Watsica LLP']
        end
      end
    end

    context 'when there are a mix of hard and soft' do
      let(:service_codes) { %w[F.4 F.6 G.4 H.6 H.8 J.6 P.2 Q.1] }
      let(:region_codes) { %w[UKH1 UKH2 UKH3] }
      let(:sector_code) { 5 }

      context 'and the contract_cost is less than 1,000,000' do
        let(:contract_cost) { rand(1_000_000) }

        it 'returns 1a for the lot number' do
          expect(lot_number).to eq '1a'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end

      context 'and the contract_cost is a more than 1,000,000 and less than 7,000,000' do
        let(:contract_cost) { rand(1_000_000...7_000_000) }

        it 'returns 1b for the lot number' do
          expect(lot_number).to eq '1b'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Erdman Ltd', 'Gerlach Ltd', 'Gerlach plc', 'Gleason plc', 'Jones plc', 'Kerluke plc', 'Ondricka LLP', 'Powlowski LLP', 'Shanahan Ltd', 'Zulauf Ltd']
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 1c for the lot number' do
          expect(lot_number).to eq '1c'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Ankunding LLP', 'Doyle LLP', 'Greenfelder plc', 'Hettinger LLP', 'Johnston plc', 'Kuvalis Ltd', 'McKenzie LLP', 'Schulist LLP', 'Sipes plc', 'Welch Ltd']
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 1d for the lot number' do
          expect(lot_number).to eq '1d'
        end

        it 'returns the correct suppliers' do
          expect(supplier_names).to eq ['Abernathy plc', 'Feest Ltd', 'Heidenreich plc', 'Hermann LLP', 'Kshlerin plc', 'McLaughlin LLP', 'Rowe plc', 'Schiller plc', 'Tremblay LLP', 'Watsica LLP']
        end
      end
    end
  end
end
