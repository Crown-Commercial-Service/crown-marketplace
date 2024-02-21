require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SupplierRegionsHelper do
  describe 'Supplier regions helper' do
    context 'when selected regions for lot 1a' do
      it 'returns region code with true' do
        supllier_lot_data = { '1a' => { 'regions' => ['UKC1', 'UKC2', 'UKM50'], 'services' => ['A.7', 'A.12'] } }
        selected_regions = described_class.supllier_selected_regions(supllier_lot_data['1a']['regions'])
        expect(selected_regions).to include('UKC1' => true, 'UKC2' => true, 'UKM50' => true)
      end
    end
  end
end
