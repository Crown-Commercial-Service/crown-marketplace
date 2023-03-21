require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierDataController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6232' } }

  login_fm_admin

  describe 'GET #index' do
    context 'when logged in as an fm admin' do
      before { get :index }

      it 'renders the index' do
        expect(response).to render_template(:index)
      end

      it 'gets a list of all the suppliers and it is sorted' do
        suppliers = assigns(:suppliers)
        first_supplier = FacilitiesManagement::RM6232::Supplier.order(:supplier_name).first

        expect(suppliers.size).to eq 50
        expect(suppliers.first.attributes).to eq({ 'id' => first_supplier.id, 'supplier_name' => first_supplier.supplier_name })
      end
    end

    context 'when not logged in as an fm admin' do
      login_fm_buyer

      it 'redirects to not permitted page' do
        get :index
        expect(response).to redirect_to '/facilities-management/RM6232/admin/not-permitted'
      end
    end
  end
end
