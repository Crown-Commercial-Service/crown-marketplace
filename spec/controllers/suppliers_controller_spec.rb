require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
  describe 'GET master_vendors' do
    let(:supplier) { build(:supplier) }
    let(:suppliers) { [supplier] }

    before do
      allow(Supplier).to receive(:with_master_vendor_rates).and_return(suppliers)
    end

    it 'renders the master_vendors template' do
      get :master_vendors
      expect(response).to render_template('master_vendors')
    end

    it 'assigns suppliers with master vendor rates to suppliers' do
      get :master_vendors
      expect(assigns(:suppliers)).to eq(suppliers)
    end
  end
end
