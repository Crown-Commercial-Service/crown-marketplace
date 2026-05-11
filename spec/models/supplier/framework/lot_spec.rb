require 'rails_helper'

RSpec.describe Supplier::Framework::Lot do
  let(:supplier_framework_lot) { create(:supplier_framework_lot) }

  describe 'associations' do
    it { is_expected.to belong_to(:supplier_framework) }
    it { is_expected.to belong_to(:lot) }

    it { is_expected.to have_many(:services) }
    it { is_expected.to have_many(:jurisdictions) }
    it { is_expected.to have_many(:rates) }
    it { is_expected.to have_many(:branches) }

    it 'has the supplier_framework relationship' do
      expect(supplier_framework_lot.supplier_framework).to be_present
    end

    it 'has the lot relationship' do
      expect(supplier_framework_lot.lot).to be_present
    end
  end

  describe 'uniqueness' do
    let(:supplier_framework) { create(:supplier_framework) }
    let(:lot) { create(:lot) }

    it 'raises an error if a record already exists for a supplier_framework and lot' do
      create(:supplier_framework_lot, supplier_framework:, lot:)

      expect { create(:supplier_framework_lot, supplier_framework:, lot:) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe 'validations' do
    before { supplier_framework_lot.assign_attributes(attributes) }

    context 'when validating lot_status' do
      let(:attributes) { { enabled: } }

      let(:enabled) { true }

      context 'when considering the enabled status' do
        context 'and it is nil' do
          let(:enabled) { nil }

          it 'is invalid and has the correct error message' do
            expect(supplier_framework_lot.valid?(:lot_status)).to be(false)
            expect(supplier_framework_lot.errors[:enabled].first).to eq('Select if the supplier is on this lot')
          end
        end

        context 'and it is blank' do
          let(:enabled) { '' }

          it 'is invalid and has the correct error message' do
            expect(supplier_framework_lot.valid?(:lot_status)).to be(false)
            expect(supplier_framework_lot.errors[:enabled].first).to eq('Select if the supplier is on this lot')
          end
        end

        context 'and it is true' do
          it 'is valid' do
            expect(supplier_framework_lot).to be_valid(:lot_status)
          end
        end

        context 'and it is false' do
          let(:enabled) { false }

          it 'is valid' do
            expect(supplier_framework_lot).to be_valid(:lot_status)
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
