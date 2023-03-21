require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SupplierDetailsHelper do
  describe '.supplier_details_index_path' do
    let(:result) { helper.supplier_details_index_path }

    before { @framework = framework }

    context 'when the framework is RM3830' do
      let(:framework) { 'RM3830' }

      it 'returns facilities_management_rm3830_admin_supplier_details_path' do
        expect(result).to eq facilities_management_rm3830_admin_supplier_details_path
      end
    end

    context 'when the framework is RM6232' do
      let(:framework) { 'RM6232' }

      it 'returns facilities_management_rm6232_admin_supplier_data_path' do
        expect(result).to eq facilities_management_rm6232_admin_supplier_data_path
      end
    end

    context 'when the framework is neither RM3830 or RM6232' do
      let(:framework) { 'RM1007' }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end
  end
end
