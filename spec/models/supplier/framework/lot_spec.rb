require 'rails_helper'

RSpec.describe Supplier::Framework::Lot do
  describe 'associations' do
    let(:supplier_framework_lot) { create(:supplier_framework_lot) }

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
end
