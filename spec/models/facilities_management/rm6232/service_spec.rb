require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Service, type: :model do
  describe '.work_package' do
    let(:result) { described_class.find(code).work_package.code }

    context 'when the code is A.10' do
      let(:code) { 'A.10' }

      it 'has the right work package A' do
        expect(result).to eq 'A'
      end
    end

    context 'when the code is E.21' do
      let(:code) { 'E.21' }

      it 'has the right work package E' do
        expect(result).to eq 'E'
      end
    end

    context 'when the code is J.14' do
      let(:code) { 'J.14' }

      it 'has the right work package J' do
        expect(result).to eq 'J'
      end
    end

    context 'when the code is M.3' do
      let(:code) { 'M.3' }

      it 'has the right work package M' do
        expect(result).to eq 'M'
      end
    end

    context 'when the code is Q.1' do
      let(:code) { 'Q.1' }

      it 'has the right work package Q' do
        expect(result).to eq 'Q'
      end
    end
  end

  describe '.available_lots' do
    let(:result) { described_class.find(code).available_lots }

    context 'when the service is available in total and hard' do
      let(:code) { 'F.4' }

      it 'returns total and hard' do
        expect(result).to eq ['total', 'hard']
      end
    end

    context 'when the service is available in total and soft' do
      let(:code) { 'I.10' }

      it 'returns total and soft' do
        expect(result).to eq ['total', 'soft']
      end
    end

    context 'when the service is available in total, hard and soft' do
      let(:code) { 'G.3' }

      it 'returns total and soft' do
        expect(result).to eq ['total', 'hard', 'soft']
      end
    end

    context 'when the service is available in total' do
      let(:code) { 'O.2' }

      it 'returns total' do
        expect(result).to eq ['total']
      end
    end

    context 'when the service is available in soft' do
      let(:code) { 'P.1' }

      it 'returns soft' do
        expect(result).to eq ['soft']
      end
    end
  end

  describe '.hyphenate_code' do
    let(:result) { described_class.find(code).hyphenate_code }

    context 'when the code is E.7' do
      let(:code) { 'E.7' }

      it 'returns E-7' do
        expect(result).to eq 'E-7'
      end
    end

    context 'when the code is K.3' do
      let(:code) { 'K.3' }

      it 'returns K-3' do
        expect(result).to eq 'K-3'
      end
    end

    context 'when the code is L.2' do
      let(:code) { 'L.2' }

      it 'returns L-2' do
        expect(result).to eq 'L-2'
      end
    end

    context 'when the code is N.4' do
      let(:code) { 'N.4' }

      it 'returns N-4' do
        expect(result).to eq 'N-4'
      end
    end

    context 'when the code is R.1' do
      let(:code) { 'R.1' }

      it 'returns R-1' do
        expect(result).to eq 'R-1'
      end
    end
  end

  describe '.determine_lot_code' do
    let(:result) { described_class.determine_lot_code(lot_number, contract_cost) }

    context 'when the lot number is 1' do
      let(:lot_number) { '1' }

      context 'and the contract_cost is less than 1,000,000' do
        let(:contract_cost) { rand(1_000_000) }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'and the contract_cost is 1,000,000' do
        let(:contract_cost) { 1_000_000 }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'and the contract_cost is a little more than 1,000,000' do
        let(:contract_cost) { 1_000_001 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is a more than 1,000,000 and less than 7,000,000' do
        let(:contract_cost) { rand(1_000_000...7_000_000) }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is 7,000,000' do
        let(:contract_cost) { 7_000_000 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is a little more than 7,000,000' do
        let(:contract_cost) { 7_000_001 }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end

      context 'and the contract_cost is 50,000,000' do
        let(:contract_cost) { 50_000_000 }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end

      context 'and the contract_cost is a little more than 50,000,000' do
        let(:contract_cost) { 50_000_001 }

        it 'returns d' do
          expect(result).to eq 'd'
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns d' do
          expect(result).to eq 'd'
        end
      end
    end

    context 'when the lot number is 2' do
      let(:lot_number) { '2' }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'and the contract_cost is 7,000,000' do
        let(:contract_cost) { 7_000_000 }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'and the contract_cost is a little more than 7,000,000' do
        let(:contract_cost) { 7_000_001 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is 50,000,000' do
        let(:contract_cost) { 50_000_000 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is a little more than 50,000,000' do
        let(:contract_cost) { 50_000_001 }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end
    end

    context 'when the lot number is 3' do
      let(:lot_number) { '3' }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'and the contract_cost is 7,000,000' do
        let(:contract_cost) { 7_000_000 }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'and the contract_cost is a little more than 7,000,000' do
        let(:contract_cost) { 7_000_001 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is 50,000,000' do
        let(:contract_cost) { 50_000_000 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'and the contract_cost is a little more than 50,000,000' do
        let(:contract_cost) { 50_000_001 }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end
    end
  end

  describe '.determine_lot_number' do
    let(:result) { described_class.determine_lot_number(service_codes) }

    context 'when all services are hard' do
      let(:service_codes) { %w[E.1 F.8 N.12] }

      it 'returns 2 (hard)' do
        expect(result).to eq '2'
      end
    end

    context 'when all services are soft' do
      let(:service_codes) { %w[H.5 I.9 N.5 P.1] }

      it 'returns 3 (soft)' do
        expect(result).to eq '3'
      end
    end

    context 'when all services are just total' do
      let(:service_codes) { %w[O.1 O.2 O.3 O.4 O.5] }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are hard services with some that are just total' do
      let(:service_codes) { %w[E.1 F.8 N.12 O.1 O.2 O.3 O.4 O.5] }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are hard services with some that are total with soft' do
      let(:service_codes) { %w[E.1 F.8 G.3 N.10 N.12 Q.1] }

      it 'returns 2 (hard)' do
        expect(result).to eq '2'
      end
    end

    context 'when there are soft services with some that are just total' do
      let(:service_codes) { %w[H.5 I.9 N.5 O.1 O.2 O.3 O.4 O.5] }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are soft services with some that are total with hard' do
      let(:service_codes) { %w[H.5 I.9 N.5 P.2 R.1] }

      it 'returns 3 (soft)' do
        expect(result).to eq '3'
      end
    end

    context 'when there are total services with some that are hard and soft' do
      let(:service_codes) { %w[E.1 F.8 H.5 I.9 N.5 N.12 O.1 O.2 O.3 O.4 O.5 P.2] }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are soft and hard services' do
      let(:service_codes) { %w[E.1 F.8 H.5 I.9 N.5 N.12] }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are total services which are hard and soft' do
      let(:service_codes) { %w[G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8] }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are total services which are hard and soft with on hard service' do
      let(:service_codes) { %w[E.1 G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8] }

      it 'returns 2 (hard)' do
        expect(result).to eq '2'
      end
    end

    context 'when there are total services which are hard and soft with on soft service' do
      let(:service_codes) { %w[G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 H.1] }

      it 'returns 3 (soft)' do
        expect(result).to eq '3'
      end
    end
  end

  describe '.find_lot_number' do
    let(:result) { described_class.find_lot_number(service_codes, contract_cost) }

    context 'when all services are hard' do
      let(:service_codes) { %w[E.9 F.5 G.1] }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns 2a' do
          expect(result).to eq '2a'
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 2b' do
          expect(result).to eq '2b'
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 2c' do
          expect(result).to eq '2c'
        end
      end
    end

    context 'when all services are soft' do
      let(:service_codes) { %w[G.8 I.4 J.1 N.5] }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns 3a' do
          expect(result).to eq '3a'
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 3b' do
          expect(result).to eq '3b'
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 3c' do
          expect(result).to eq '3c'
        end
      end
    end

    context 'when there are a mix of hard and total' do
      let(:service_codes) { %w[E.9 F.5 G.1 P.2] }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns 2a' do
          expect(result).to eq '2a'
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 2b' do
          expect(result).to eq '2b'
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 2c' do
          expect(result).to eq '2c'
        end
      end
    end

    context 'when there are a mix of soft and total' do
      let(:service_codes) { %w[G.8 I.4 J.1 N.5 Q.1] }

      context 'and the contract_cost is less than 7,000,000' do
        let(:contract_cost) { rand(7_000_000) }

        it 'returns 3a' do
          expect(result).to eq '3a'
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 3b' do
          expect(result).to eq '3b'
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 3c' do
          expect(result).to eq '3c'
        end
      end
    end

    context 'when there are a mix of hard and soft' do
      let(:service_codes) { %w[E.9 F.5 G.1 G.8 I.4 J.1 N.5] }

      context 'and the contract_cost is less than 1,000,000' do
        let(:contract_cost) { rand(1_000_000) }

        it 'returns 1a' do
          expect(result).to eq '1a'
        end
      end

      context 'and the contract_cost is a more than 1,000,000 and less than 7,000,000' do
        let(:contract_cost) { rand(1_000_000...7_000_000) }

        it 'returns 1b' do
          expect(result).to eq '1b'
        end
      end

      context 'and the contract_cost is a more than 7,000,000 and less than 50,000,000' do
        let(:contract_cost) { rand(7_000_000...50_000_000) }

        it 'returns 1c' do
          expect(result).to eq '1c'
        end
      end

      context 'and the contract_cost is more than 50,000,000' do
        let(:contract_cost) { rand(50_000_000...100_000_000) }

        it 'returns 1d' do
          expect(result).to eq '1d'
        end
      end
    end
  end
end
