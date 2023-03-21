require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Service do
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

  describe '.determine_lot_code' do
    let(:result) { described_class.determine_lot_code(lot_number, annual_contract_value) }

    context 'when the lot number is 1' do
      let(:lot_number) { '1' }

      context 'when the annual_contract_value is less than 1,500,000' do
        let(:annual_contract_value) { rand(1_500_000) }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'when the annual_contract_value is 1,500,000' do
        let(:annual_contract_value) { 1_500_000 }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'when the annual_contract_value is a little more than 1,500,000' do
        let(:annual_contract_value) { 1_500_001 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is a more than 1,500,000 and less than 10,000,000' do
        let(:annual_contract_value) { rand(1_500_000...10_000_000) }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is 10,000,000' do
        let(:annual_contract_value) { 10_000_000 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is a little more than 10,000,000' do
        let(:annual_contract_value) { 10_000_001 }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end

      context 'when the annual_contract_value is more than 10,000,000' do
        let(:annual_contract_value) { rand(10_000_000...50_000_000) }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end
    end

    context 'when the lot number is 2' do
      let(:lot_number) { '2' }

      context 'when the annual_contract_value is less than 1,500,000' do
        let(:annual_contract_value) { rand(1_500_000) }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'when the annual_contract_value is 1,500,000' do
        let(:annual_contract_value) { 1_500_000 }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'when the annual_contract_value is a little more than 1,500,000' do
        let(:annual_contract_value) { 1_500_001 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is a more than 1,500,000 and less than 10,000,000' do
        let(:annual_contract_value) { rand(1_500_000...10_000_000) }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is 10,000,000' do
        let(:annual_contract_value) { 10_000_000 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is a little more than 10,000,000' do
        let(:annual_contract_value) { 10_000_001 }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end

      context 'when the annual_contract_value is more than 10,000,000' do
        let(:annual_contract_value) { rand(10_000_000...50_000_000) }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end
    end

    context 'when the lot number is 3' do
      let(:lot_number) { '3' }

      context 'when the annual_contract_value is less than 1,000,000' do
        let(:annual_contract_value) { rand(1_000_000) }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'when the annual_contract_value is 1,000,000' do
        let(:annual_contract_value) { 1_000_000 }

        it 'returns a' do
          expect(result).to eq 'a'
        end
      end

      context 'when the annual_contract_value is a little more than 1,000,000' do
        let(:annual_contract_value) { 1_000_001 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is a more than 1,000,000 and less than 7,000,000' do
        let(:annual_contract_value) { rand(1_000_000...7_000_000) }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is 7,000,000' do
        let(:annual_contract_value) { 7_000_000 }

        it 'returns b' do
          expect(result).to eq 'b'
        end
      end

      context 'when the annual_contract_value is a little more than 7,000,000' do
        let(:annual_contract_value) { 7_000_001 }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end

      context 'when the annual_contract_value is more than 7,000,000' do
        let(:annual_contract_value) { rand(7_000_000...50_000_000) }

        it 'returns c' do
          expect(result).to eq 'c'
        end
      end
    end
  end

  describe '.determine_lot_number' do
    let(:selection_one) { { total: false, hard: false, soft: false } }
    let(:selection_one_sample) { 3 }
    let(:selection_two) { { total: false, hard: false, soft: false } }
    let(:selection_two_sample) { 3 }
    let(:service_codes) { described_class.where(**selection_one).sample(selection_one_sample).pluck(:code) + described_class.where(**selection_two).sample(selection_two_sample).pluck(:code) }

    let(:result) { described_class.determine_lot_number(service_codes) }

    context 'when all services are hard' do
      let(:selection_one) { { total: true, hard: true, soft: false } }
      let(:selection_one_sample) { 5 }

      it 'returns 2 (hard)' do
        expect(result).to eq '2'
      end
    end

    context 'when all services are soft' do
      let(:selection_one) { { total: true, hard: false, soft: true } }
      let(:selection_one_sample) { 5 }

      it 'returns 3 (soft)' do
        expect(result).to eq '3'
      end
    end

    context 'when all services are just total' do
      let(:selection_one) { { total: true, hard: false, soft: false } }
      let(:selection_one_sample) { 5 }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are hard services with some that are just total' do
      let(:selection_one) { { total: true, hard: true, soft: false } }
      let(:selection_two) { { total: true, hard: false, soft: false } }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are hard services with some that are total with soft' do
      let(:selection_one) { { total: true, hard: true, soft: false } }
      let(:selection_two) { { total: true, hard: true, soft: true } }

      it 'returns 2 (hard)' do
        expect(result).to eq '2'
      end
    end

    context 'when there are soft services with some that are just total' do
      let(:selection_one) { { total: true, hard: false, soft: true } }
      let(:selection_two) { { total: true, hard: false, soft: false } }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are soft services with some that are total with hard' do
      let(:selection_one) { { total: true, hard: false, soft: true } }
      let(:selection_two) { { total: true, hard: true, soft: true } }

      it 'returns 3 (soft)' do
        expect(result).to eq '3'
      end
    end

    context 'when there are total services with some that are hard and soft' do
      let(:selection_one) { { total: true, hard: false, soft: true } }
      let(:selection_two) { { total: true, hard: true, soft: false } }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are soft and hard services' do
      let(:selection_one) { { total: true, hard: true, soft: false } }
      let(:selection_two) { { total: true, hard: false, soft: true } }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are total services which are hard and soft' do
      let(:selection_one) { { total: true, hard: true, soft: true } }
      let(:selection_one_sample) { 5 }

      it 'returns 1 (total)' do
        expect(result).to eq '1'
      end
    end

    context 'when there are total services which are hard and soft with one hard service' do
      let(:selection_one) { { total: true, hard: true, soft: true } }
      let(:selection_two) { { total: true, hard: true, soft: false } }
      let(:selection_one_sample) { 5 }
      let(:selection_two_sample) { 1 }

      it 'returns 2 (hard)' do
        expect(result).to eq '2'
      end
    end

    context 'when there are total services which are hard and soft with one soft service' do
      let(:selection_one) { { total: true, hard: true, soft: true } }
      let(:selection_two) { { total: true, hard: false, soft: true } }
      let(:selection_one_sample) { 5 }
      let(:selection_two_sample) { 1 }

      it 'returns 3 (soft)' do
        expect(result).to eq '3'
      end
    end
  end

  describe '.find_lot_number' do
    let(:selection_one) { { total: false, hard: false, soft: false } }
    let(:selection_two) { { total: false, hard: false, soft: false } }
    let(:service_codes) { described_class.where(**selection_one).sample(3).pluck(:code) + described_class.where(**selection_two).sample(3).pluck(:code) }

    let(:result) { described_class.find_lot_number(service_codes, annual_contract_value) }

    context 'when all services are hard' do
      let(:selection_one) { { total: true, hard: true, soft: false } }

      context 'and the annual_contract_value is less than 1,500,000' do
        let(:annual_contract_value) { rand(1_500_000) }

        it 'returns 2a' do
          expect(result).to eq '2a'
        end
      end

      context 'and the annual_contract_value is a more than 1,500,000 and less than 10,000,000' do
        let(:annual_contract_value) { rand(1_500_000...10_000_000) }

        it 'returns 2b' do
          expect(result).to eq '2b'
        end
      end

      context 'and the annual_contract_value is more than 10,000,000' do
        let(:annual_contract_value) { rand(10_000_000...50_000_000) }

        it 'returns 2c' do
          expect(result).to eq '2c'
        end
      end
    end

    context 'when all services are soft' do
      let(:selection_one) { { total: true, hard: false, soft: true } }

      context 'and the annual_contract_value is less than 1,000,000' do
        let(:annual_contract_value) { rand(1_000_000) }

        it 'returns 3a' do
          expect(result).to eq '3a'
        end
      end

      context 'and the annual_contract_value is a more than 1,000,000 and less than 7,000,000' do
        let(:annual_contract_value) { rand(1_000_000...7_000_000) }

        it 'returns 3b' do
          expect(result).to eq '3b'
        end
      end

      context 'and the annual_contract_value is more than 7,000,000' do
        let(:annual_contract_value) { rand(7_000_000...50_000_000) }

        it 'returns 3c' do
          expect(result).to eq '3c'
        end
      end
    end

    context 'when there are a mix of hard and soft' do
      let(:selection_one) { { total: true, hard: true, soft: false } }
      let(:selection_two) { { total: true, hard: false, soft: true } }

      context 'and the annual_contract_value is less than 1,500,000' do
        let(:annual_contract_value) { rand(1_500_000) }

        it 'returns 1a' do
          expect(result).to eq '1a'
        end
      end

      context 'and the annual_contract_value is a more than 1,500,000 and less than 10,000,000' do
        let(:annual_contract_value) { rand(1_500_000...10_000_000) }

        it 'returns 1b' do
          expect(result).to eq '1b'
        end
      end

      context 'and the annual_contract_value is more than 10,000,000' do
        let(:annual_contract_value) { rand(10_000_000...50_000_000) }

        it 'returns 1c' do
          expect(result).to eq '1c'
        end
      end
    end
  end
end
