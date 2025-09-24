require 'rails_helper'

RSpec.describe Supplier::Framework::Lot::Rate do
  let(:supplier_framework_lot_rate) { create(:supplier_framework_lot_rate) }

  describe 'associations' do
    it { is_expected.to belong_to(:supplier_framework_lot) }
    it { is_expected.to belong_to(:position) }
    it { is_expected.to belong_to(:jurisdiction) }

    it 'has the supplier_framework_lot relationship' do
      expect(supplier_framework_lot_rate.supplier_framework_lot).to be_present
    end

    it 'has the position relationship' do
      expect(supplier_framework_lot_rate.position).to be_present
    end

    it 'has the jurisdiction relationship' do
      expect(supplier_framework_lot_rate.jurisdiction).to be_present
    end
  end

  describe 'uniqueness' do
    let(:supplier_framework_lot) { create(:supplier_framework_lot) }
    let(:position) { create(:position) }
    let(:jurisdiction) { create(:supplier_framework_lot_jurisdiction) }

    it 'raises an error if a record already exists for a supplier_framework_lot, position and jurisdiction' do
      create(:supplier_framework_lot_rate, supplier_framework_lot:, position:, jurisdiction:)

      expect { create(:supplier_framework_lot_rate, supplier_framework_lot:, position:, jurisdiction:) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe '.rate_in_pounds' do
    before { supplier_framework_lot_rate.rate = rate }

    context 'and the rate is 3550' do
      let(:rate) { 3550 }

      it 'returns 35' do
        expect(supplier_framework_lot_rate.rate_in_pounds).to eq 35.5
      end
    end

    context 'and the rate is 1200' do
      let(:rate) { 1200 }

      it 'returns 12.0' do
        expect(supplier_framework_lot_rate.rate_in_pounds).to eq 12.0
      end
    end
  end

  describe '.rate_as_percentage' do
    before { supplier_framework_lot_rate.rate = rate }

    context 'and the rate is 3550' do
      let(:rate) { 3550 }

      it 'returns 35' do
        expect(supplier_framework_lot_rate.rate_as_percentage).to eq 35.5
      end
    end

    context 'and the rate is 1200' do
      let(:rate) { 1200 }

      it 'returns 12.0' do
        expect(supplier_framework_lot_rate.rate_as_percentage).to eq 12.0
      end
    end
  end

  describe '.rate_as_percentage_decimal' do
    before { supplier_framework_lot_rate.rate = rate }

    context 'and the rate is 3550' do
      let(:rate) { 3550 }

      it 'returns 35' do
        expect(supplier_framework_lot_rate.rate_as_percentage_decimal).to eq 0.355
      end
    end

    context 'and the rate is 1200' do
      let(:rate) { 1200 }

      it 'returns 12.0' do
        expect(supplier_framework_lot_rate.rate_as_percentage_decimal).to eq 0.12
      end
    end
  end
end
