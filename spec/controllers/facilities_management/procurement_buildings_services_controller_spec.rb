require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsServicesController, type: :controller do
  let(:procurement_building_service) { create(:facilities_management_procurement_building_service, procurement_building: create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement, user: subject.current_user))) }

  describe 'GET #show' do
    login_fm_buyer_with_details

    context 'when logged in as the fm buyer that created the procurement' do
      it 'returns http success' do
        get :show, params: { id: procurement_building_service.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when logged in as a different fm buyer than the one that created the procurement' do
      it 'redirects to not permitted page' do
        procurement_building_service.procurement_building.procurement.update(user: create(:user))
        get :show, params: { id: procurement_building_service.id }
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end

    context 'when on the show page' do
      it 'renders the edit page' do
        get :show, params: { id: procurement_building_service.id }

        expect(response).to render_template('edit')
      end
    end
  end

  describe 'PATCH update' do
    login_fm_buyer_with_details

    context 'when updating lift data' do
      context 'when the lift data is valid' do
        let(:lifts) { ['10', '13', '7', '6'] }

        before do
          patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { step: 'lifts', lift_data: lifts } }
        end

        it 'redirects to facilities_management_procurement_building_path' do
          expect(response).to redirect_to facilities_management_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the lift data correctly' do
          procurement_building_service.reload

          expect(procurement_building_service.lift_data).to eq lifts
        end
      end

      context 'when the lift data is not valid' do
        it 'renders the edit page' do
          patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { step: 'lifts', lift_data: ['10', '0', '7', '6'] } }

          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating service hour data' do
      context 'when the service hour data is valid' do
        let(:service_hours) { 506 }
        let(:detail_of_requirement) { 'Detail of the requirement' }

        before do
          patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { step: 'service_hours', service_hours: service_hours, detail_of_requirement: detail_of_requirement } }
        end

        it 'redirects to facilities_management_procurement_building_path' do
          expect(response).to redirect_to facilities_management_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the service hour data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.service_hours).to eq service_hours
          expect(procurement_building_service.detail_of_requirement).to eq detail_of_requirement
        end
      end

      context 'when the service hour is not valid' do
        let(:service_hours) { 0 }
        let(:detail_of_requirement) { '' }

        it 'renders the edit page' do
          patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { step: 'service_hours', service_hours: service_hours, detail_of_requirement: detail_of_requirement } }

          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating neither lift or service hour data' do
      it 'redirects to facilities_management_procurement_building_path' do
        patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { step: nil } }

        expect(response).to redirect_to facilities_management_procurement_building_path(procurement_building_service.procurement_building)
      end
    end
  end
end
