require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsServicesController, type: :controller do
  let(:procurement_building_service) { create(:facilities_management_procurement_building_service, procurement_building: create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement, user: subject.current_user))) }

  describe 'GET #show' do
    context 'when logged in as the fm buyer that created the procurement' do
      login_fm_buyer_with_details
      it 'returns http success' do
        get :show, params: { id: procurement_building_service.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when logged in as a different fm buyer than the one that created the procurement' do
      login_fm_buyer_with_details

      it 'redirects to not permitted page' do
        procurement_building_service.procurement_building.procurement.update(user: create(:user))
        get :show, params: { id: procurement_building_service.id }
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end
  end
end
