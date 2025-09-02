require 'rails_helper'

RSpec.describe Supplier::Framework::Lot::Jurisdiction do
  describe 'associations' do
    let(:supplier_framework_lot_jurisdiction) { create(:supplier_framework_lot_jurisdiction) }

    it { is_expected.to belong_to(:supplier_framework_lot) }
    it { is_expected.to belong_to(:jurisdiction) }

    it { is_expected.to have_many(:rates) }

    it 'has the supplier_framework_lot relationship' do
      expect(supplier_framework_lot_jurisdiction.supplier_framework_lot).to be_present
    end

    it 'has the jurisdiction relationship' do
      expect(supplier_framework_lot_jurisdiction.jurisdiction).to be_present
    end
  end

  describe 'uniqueness' do
    let(:supplier_framework_lot) { create(:supplier_framework_lot) }
    let(:jurisdiction) { create(:jurisdiction) }

    it 'raises an error if a record already exists for a supplier_framework_lot and jurisdiction' do
      create(:supplier_framework_lot_jurisdiction, supplier_framework_lot:, jurisdiction:)

      expect { create(:supplier_framework_lot_jurisdiction, supplier_framework_lot:, jurisdiction:) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
