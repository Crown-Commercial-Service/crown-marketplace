require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SublotRegionsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }
  let(:supplier) { FacilitiesManagement::RM3830::Admin::SuppliersAdmin.find_by(supplier_name: 'Abernathy and Sons') }
  let(:supplier_id) { supplier.supplier_id }

  login_fm_admin

  before do
    supplier.update(lot_data: {
                      '1a': { regions: ['UKC1', 'UKC2', 'UKD1'], services: ['A.7', 'A.12'] },
                      '1b': { regions: ['UKC1', 'UKC2'], services: ['A.7', 'A.12'] },
                      '1c': { regions: ['UKC1', 'UKC2'], services: ['A.7', 'A.12'] }
                    })
  end

  describe 'GET edit' do
    context 'when checking permissions' do
      context 'when an fm amdin' do
        before { get :edit, params: { supplier_framework_datum_id: supplier_id, lot: '1a' } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when not an fm admin' do
        login_fm_buyer

        before { get :edit, params: { supplier_framework_datum_id: supplier_id, lot: '1a' } }

        it 'redirects to not permitted page' do
          expect(response).to redirect_to '/facilities-management/RM3830/admin/not-permitted'
        end
      end
    end

    context 'when viewing the edit page' do
      before { get :edit, params: { supplier_framework_datum_id: supplier_id, lot: lot_number } }

      context 'and the lot is 1a' do
        let(:lot_number) { '1a' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'assigns the sublot region name' do
          expect(assigns(:sublot_region_name)).to eq 'Sub-lot 1a regions'
        end
      end

      context 'and the lot is 1b' do
        let(:lot_number) { '1b' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'assigns the sublot region name' do
          expect(assigns(:sublot_region_name)).to eq 'Sub-lot 1b regions'
        end
      end

      context 'and the lot is 1c' do
        let(:lot_number) { '1c' }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'assigns the sublot region name' do
          expect(assigns(:sublot_region_name)).to eq 'Sub-lot 1c regions'
        end
      end

      context 'and the lot does not exist' do
        let(:lot_number) { '1e' }

        it 'redirect to admin home page' do
          expect(response).to redirect_to facilities_management_rm3830_admin_path
        end
      end
    end
  end

  describe 'PUT update' do
    context 'when the framework is live' do
      include_context 'and RM3830 is live'

      before { put :update, params: { supplier_framework_datum_id: supplier_id, lot: '1a', regions: regions } }

      context 'when updating the data with regions' do
        let(:regions) { ['UKC1', 'UKC2'] }

        it 'redirects to the supplier_framework_data_path' do
          expect(response).to redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
        end

        it 'updates the regions correctly' do
          supplier.reload
          expect(supplier.lot_data['1a']['regions']).to eq regions
        end
      end

      context 'when updating the data without regions' do
        let(:regions) { [] }

        it 'redirects to the supplier_framework_data_path' do
          expect(response).to redirect_to facilities_management_rm3830_admin_supplier_framework_data_path
        end

        it 'updates the regions correctly' do
          supplier.reload
          expect(supplier.lot_data['1a']['regions']).to eq regions
        end
      end
    end

    context 'when the framework has expired' do
      before { put :update, params: { supplier_framework_datum_id: supplier_id, lot: '1a' } }

      it 'redirects to the edit page' do
        expect(response).to redirect_to edit_facilities_management_rm3830_admin_supplier_framework_datum_sublot_region_path
      end
    end
  end
end
