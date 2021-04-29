require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsController, type: :controller do
  let(:default_params) { { service: 'facilities_management' } }
  let(:procurement_building) { create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement, user: subject.current_user)) }

  describe 'GET #show' do
    context 'when logged in as the fm buyer that created the procurement' do
      login_fm_buyer_with_details
      it 'returns http success' do
        get :show, params: { id: procurement_building.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when logged in as a different fm buyer than the one that created the procurement' do
      login_fm_buyer_with_details

      it 'redirects to not permitted page' do
        procurement_building.procurement.update(user: create(:user))
        get :show, params: { id: procurement_building.id }
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end

    context 'when logging in without buyer details' do
      login_fm_buyer

      it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
        get :show, params: { id: procurement_building.id }

        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(controller.current_user.buyer_detail)
      end
    end
  end

  describe 'GET #edit' do
    login_fm_buyer_with_details

    before { get :edit, params: { id: procurement_building.id, step: step } }

    context 'when the step is not recognised' do
      let(:step) { 'missing_service' }

      it 'redirects to the  procurement show page' do
        expect(response).to redirect_to facilities_management_procurement_path(procurement_building.procurement)
      end
    end

    context 'when the step is missing_regions' do
      let(:step) { 'missing_region' }

      it 'renders the template' do
        expect(response).to render_template :edit
      end
    end

    context 'when the step is buildings_and_services' do
      let(:step) { 'buildings_and_services' }

      it 'renders the template' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'PATCH #update' do
    login_fm_buyer_with_details

    context 'when updating a missing region' do
      before do
        patch :update, params: { id: procurement_building.id, step: 'missing_region', facilities_management_building: { address_region: address_region } }
      end

      context 'when the building has a region' do
        let(:address_region) { 'Cardiff and Vale of Glamorgan' }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_procurement_path(procurement_building.procurement)
        end
      end

      context 'when the building does not have a region' do
        let(:address_region) { nil }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when updating service selections' do
      before do
        patch :update, params: { id: procurement_building.id, step: 'buildings_and_services', facilities_management_procurement_building: { service_codes: service_codes } }
      end

      context 'when no services are selected' do
        let(:service_codes) { [''] }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when services are selected' do
        let(:service_codes) { ['', 'C.1'] }

        it 'redirects to the procurement summary page' do
          expect(response).to redirect_to facilities_management_procurement_summary_path(procurement_building.procurement, summary: 'buildings_and_services')
        end
      end
    end
  end

  describe 'methods called on show' do
    login_fm_buyer_with_details

    before do
      procurement_building.update(service_codes: %w[C.1 E.4 C.2 C.3 C.4 G.3 C.5 K.4 I.3 O.1 N.1])
      procurement_building.reload
      get :show, params: { id: procurement_building.id }
    end

    context 'when set_standards_procurement_building_services is used' do
      it 'returns the correct procurement_building_services' do
        expect(assigns(:standards_procurement_building_services).map(&:code)).to eq %w[C.1 C.2 C.3 C.4 C.5 G.3]
      end
    end

    context 'when set_volume_procurement_building_services is used' do
      it 'returns the correct procurement_building_services' do
        expect(assigns(:volume_procurement_building_services).map { |service_and_context| service_and_context[:procurement_building_service].code }).to eq %w[C.1 C.2 C.3 C.4 C.5 E.4 G.3 G.3 I.3 K.4]
      end
    end
  end
end
