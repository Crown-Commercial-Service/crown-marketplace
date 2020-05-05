require 'rails_helper'

RSpec.describe FacilitiesManagement::Supplier::SupplierRegionsHelper, type: :helper do
  describe 'Supplier regions helper' do
    context 'when selected regions for lot 1a' do
      it 'will return region code with true' do
        supllier = [{ 'regions' => ['UKC1', 'UKC2', 'UKM50'], 'services' => ['A.7', 'A.12'], 'lot_number' => '1a' }]
        selected_regions = FacilitiesManagement::Supplier::SupplierRegionsHelper.supllier_selected_regions(supllier)
        expect(selected_regions).to include('UKC1' => true, 'UKC2' => true, 'UKM50' => true)
      end
    end
  end
end
