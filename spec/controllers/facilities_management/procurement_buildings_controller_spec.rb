require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsController, type: :controller do
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
  end

  describe 'PATCH #update' do
    login_fm_buyer_with_details

    context 'when updating a missing region' do
      before do
        patch :update, params: { id: procurement_building.id, add_missing_region: 'Save and return', facilities_management_building: { address_region: address_region } }
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
  end
end
