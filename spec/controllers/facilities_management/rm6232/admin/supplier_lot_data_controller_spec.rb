require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierLotDataController, type: :controller do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6232' } }

  login_fm_admin

  describe 'GET #show' do
    let(:supplier) { FacilitiesManagement::RM6232::Supplier.order(:supplier_name).sample }

    context 'when logged in as an fm admin' do
      before { get :show, params: { id: supplier.id } }

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'assigns the supplier' do
        expect(assigns(:supplier)).to eq supplier
      end

      it 'assigns the lot data' do
        expect(assigns(:lot_data).map { |lot_data| lot_data[:id] }).to eq supplier.lot_data.order(:lot_code).pluck(:id)
      end
    end

    context 'when not logged in as an fm admin' do
      login_fm_buyer

      it 'redirects to not permitted page' do
        get :show, params: { id: supplier.id }
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end

  describe 'GET edit' do
    let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, :with_supplier) }

    render_views

    before { get :edit, params: { supplier_lot_datum_id: lot_data.id, lot_data_type: lot_data_type } }

    context 'when the lot data type is region codes' do
      let(:lot_data_type) { 'region_codes' }

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'renders the region_codes partial' do
        expect(response).to render_template(partial: 'facilities_management/rm6232/admin/supplier_lot_data/_region_codes')
      end

      it 'sets the lot data' do
        expect(assigns(:lot_data)).to eq lot_data
        expect(assigns(:lot_code)).to eq lot_data.lot_code
        expect(assigns(:supplier).supplier_name).to eq lot_data.supplier_name
      end

      it 'sets the region data' do
        expect(assigns(:regions)).not_to be_nil
      end
    end

    context 'when the lot data type is not recognised' do
      let(:lot_data_type) { 'unrecognised' }

      it 'redirects back to the admin dashboard' do
        expect(response).to redirect_to facilities_management_rm6232_admin_path
      end
    end
  end

  describe 'PUT update' do
    let(:lot_data) { create(:facilities_management_rm6232_supplier_lot_data, :with_supplier) }
    let(:attributes) { {} }

    before { put :update, params: { supplier_lot_datum_id: lot_data.id, lot_data_type: lot_data_type, facilities_management_rm6232_supplier_lot_data: attributes } }

    context 'when the lot data type is region codes' do
      let(:lot_data_type) { 'region_codes' }

      context 'and the data is valid' do
        let(:attributes) { { region_codes: %w[UKD1 UKD2] } }

        it 'redirects to facilities_management_rm6232_admin_supplier_lot_datum_path' do
          expect(response).to redirect_to facilities_management_rm6232_admin_supplier_lot_datum_path(lot_data.supplier.id)
        end

        it 'sets the lot data' do
          expect(assigns(:lot_data)).to eq lot_data
          expect(assigns(:lot_code)).to eq lot_data.lot_code
          expect(assigns(:supplier).supplier_name).to eq lot_data.supplier_name
        end

        it 'does not set the region data' do
          expect(assigns(:regions)).to be_nil
        end
      end

      context 'and the data is invalid' do
        let(:attributes) { { region_codes: [] } }

        render_views

        it 'renders the edit template' do
          expect(response).to render_template(:edit)
        end

        it 'renders the region_codes partial' do
          expect(response).to render_template(partial: 'facilities_management/rm6232/admin/supplier_lot_data/_region_codes')
        end

        it 'sets the lot data' do
          expect(assigns(:lot_data)).to eq lot_data
          expect(assigns(:lot_code)).to eq lot_data.lot_code
          expect(assigns(:supplier).supplier_name).to eq lot_data.supplier_name
        end

        it 'sets the region data' do
          expect(assigns(:regions)).not_to be_nil
        end
      end
    end

    context 'when the lot data type is not recognised' do
      let(:lot_data_type) { 'something else' }

      it 'redirects back to the admin dashboard' do
        expect(response).to redirect_to facilities_management_rm6232_admin_path
      end
    end
  end
end
