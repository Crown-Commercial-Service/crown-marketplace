require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SublotServicesController, type: :controller do
  login_admin_buyer

  let(:id) { 'ca57bf4c-e8a5-468a-95f4-39fcf730c770' }
  let(:target_lot) { '1b' }

  describe 'GET index' do
    context 'with valid ID' do
      it 'returns http success' do
        get :index, params: { id: id, lot: target_lot }
        expect(response).to have_http_status(:ok)
      end

      it 'renders the index page' do
        get :index, params: { id: id, lot: target_lot }
        expect(response).to render_template(:index)
      end

      it 'retrieves correct name data' do
        get :index, params: { id: id, lot: target_lot }
        expect(assigns(:supplier_name)).to eq 'Abernathy and Sons'
        expect(assigns(:lot_name)).to eq 'Sub-lot 1b services'
      end

      it 'retrieves correct service data' do
        get :index, params: { id: id, lot: target_lot }
        expect(assigns(:supplier_rate_data_checkboxes).size).to eq 116
        expect(assigns(:full_services).size).to eq 13
      end
    end

    context 'with invalid ID' do
      it 'returns http redirect' do
        get :index, params: { id: '124', lot: target_lot }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'PUT update' do
    before do
      put :update, params: { id: id, lot: target_lot, checked_services: new_services }
    end

    let(:new_services) { %w[bish bosh bash] }
    let(:record) { FacilitiesManagement::Admin::SuppliersAdmin.find(id) }

    let(:updated_lot_data) do
      record.data['lots'].select { |lot| lot['lot_number'] == target_lot } .first
    end

    context 'with lot 1b' do
      it 'updates the supplier' do
        expect(updated_lot_data['services']).to eq(new_services)
      end

      it 'redirects to admin dashboard' do
        expect(response).to redirect_to(facilities_management_admin_supplier_framework_data_path)
      end
    end

    context 'with lot 1c' do
      let(:id) { 'f644dfef-c534-4432-9bbc-f537e02652e6' }
      let(:target_lot) { '1c' }

      it 'updates the supplier' do
        expect(updated_lot_data['services']).to eq(new_services)
      end

      it 'redirects to admin dashboard' do
        expect(response).to redirect_to(facilities_management_admin_supplier_framework_data_path)
      end
    end
  end
end
