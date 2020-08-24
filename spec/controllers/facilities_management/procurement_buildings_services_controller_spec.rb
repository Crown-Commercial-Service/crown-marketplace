require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementBuildingsServicesController, type: :controller do
  let(:procurement_building_service) { create(:facilities_management_procurement_building_service, procurement_building: create(:facilities_management_procurement_building, procurement: create(:facilities_management_procurement, user: subject.current_user))) }

  describe 'GET #edit' do
    login_fm_buyer_with_details

    context 'when logged in as the fm buyer that created the procurement' do
      it 'returns http success' do
        get :edit, params: { id: procurement_building_service.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when logged in as a different fm buyer than the one that created the procurement' do
      it 'redirects to not permitted page' do
        procurement_building_service.procurement_building.procurement.update(user: create(:user))
        get :edit, params: { id: procurement_building_service.id }
        expect(response).to redirect_to not_permitted_path(service: 'facilities_management')
      end
    end

    context 'when on the show page' do
      it 'renders the edit page' do
        get :edit, params: { id: procurement_building_service.id }

        expect(response).to render_template('edit')
      end
    end
  end

  describe 'PATCH update' do
    login_fm_buyer_with_details

    context 'when updating lift data' do
      before do
        procurement_building_service.update(code: 'C.5')
        patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { service_question: 'lifts', lift_data: lifts } }
      end

      context 'when the lift data is valid' do
        let(:lifts) { ['10', '13', '7', '6'] }

        it 'redirects to facilities_management_procurement_building_path' do
          expect(response).to redirect_to facilities_management_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the lift data correctly' do
          procurement_building_service.reload

          expect(procurement_building_service.lift_data).to eq lifts
        end
      end

      context 'when the lift data is not valid' do
        let(:lifts) { ['10', '0', '7', '6'] }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating service hour data' do
      before do
        procurement_building_service.update(code: 'J.1')
        patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { service_question: 'service_hours', service_hours: service_hours, detail_of_requirement: detail_of_requirement } }
      end

      context 'when the service hour data is valid' do
        let(:service_hours) { 506 }
        let(:detail_of_requirement) { 'Detail of the requirement' }

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
          patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { service_question: 'service_hours', service_hours: service_hours, detail_of_requirement: detail_of_requirement } }

          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating no_of_appliances_for_testing data' do
      before do
        procurement_building_service.update(code: 'E.4')
        patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { service_question: 'volumes', no_of_appliances_for_testing: no_of_appliances_for_testing } }
      end

      context 'when the no_of_appliances_for_testing data is valid' do
        let(:no_of_appliances_for_testing) { 506 }

        it 'redirects to facilities_management_procurement_building_path' do
          expect(response).to redirect_to facilities_management_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the no_of_appliances_for_testing data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.no_of_appliances_for_testing).to eq no_of_appliances_for_testing
        end
      end

      context 'when the no_of_appliances_for_testing is not valid' do
        let(:no_of_appliances_for_testing) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating tones_to_be_collected_and_removed data' do
      before do
        procurement_building_service.update(code: 'K.2')
        patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { service_question: 'volumes', tones_to_be_collected_and_removed: tones_to_be_collected_and_removed } }
      end

      context 'when the tones_to_be_collected_and_removed data is valid' do
        let(:tones_to_be_collected_and_removed) { 1000 }

        it 'redirects to facilities_management_procurement_building_path' do
          expect(response).to redirect_to facilities_management_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the tones_to_be_collected_and_removed data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.tones_to_be_collected_and_removed).to eq tones_to_be_collected_and_removed
        end
      end

      context 'when the tones_to_be_collected_and_removed is not valid' do
        let(:tones_to_be_collected_and_removed) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating no_of_units_to_be_serviced data' do
      before do
        procurement_building_service.update(code: 'K.7')
        patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { service_question: 'volumes', no_of_units_to_be_serviced: no_of_units_to_be_serviced } }
      end

      context 'when the no_of_units_to_be_serviced data is valid' do
        let(:no_of_units_to_be_serviced) { 350 }

        it 'redirects to facilities_management_procurement_building_path' do
          expect(response).to redirect_to facilities_management_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the no_of_units_to_be_serviced data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.no_of_units_to_be_serviced).to eq no_of_units_to_be_serviced
        end
      end

      context 'when the no_of_appliances_for_testing is not valid' do
        let(:no_of_units_to_be_serviced) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating neither lift or service hour data' do
      it 'redirects to facilities_management_procurement_building_path' do
        patch :update, params: { id: procurement_building_service.id, facilities_management_procurement_building_service: { service_question: nil } }

        expect(response).to redirect_to facilities_management_procurement_building_path(procurement_building_service.procurement_building)
      end
    end
  end
end
