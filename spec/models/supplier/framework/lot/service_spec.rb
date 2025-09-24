require 'rails_helper'

RSpec.describe Supplier::Framework::Lot::Service do
  describe 'associations' do
    let(:supplier_framework_lot_service) { create(:supplier_framework_lot_service) }

    it { is_expected.to belong_to(:supplier_framework_lot) }
    it { is_expected.to belong_to(:service) }

    it 'has the supplier_framework_lot relationship' do
      expect(supplier_framework_lot_service.supplier_framework_lot).to be_present
    end

    it 'has the service relationship' do
      expect(supplier_framework_lot_service.service).to be_present
    end
  end

  describe 'uniqueness' do
    let(:supplier_framework_lot) { create(:supplier_framework_lot) }
    let(:service) { create(:service) }

    it 'raises an error if a record already exists for a supplier_framework_lot and service' do
      create(:supplier_framework_lot_service, supplier_framework_lot:, service:)

      expect { create(:supplier_framework_lot_service, supplier_framework_lot:, service:) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
