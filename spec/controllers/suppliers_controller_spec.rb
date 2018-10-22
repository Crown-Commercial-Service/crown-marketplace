require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
  describe 'GET master_vendor_managed_service_providers' do
    let(:supplier) { build(:supplier) }
    let(:suppliers) { [supplier] }

    before do
      allow(Supplier).to receive(:with_master_vendor_rates).and_return(suppliers)
    end

    it 'renders the master_vendor_managed_service_providers template' do
      get :master_vendor_managed_service_providers
      expect(response).to render_template('master_vendor_managed_service_providers')
    end

    it 'assigns suppliers with master vendor rates to suppliers' do
      get :master_vendor_managed_service_providers
      expect(assigns(:suppliers)).to eq(suppliers)
    end
  end
end
