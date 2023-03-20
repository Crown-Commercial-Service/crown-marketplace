require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementBuildingsServicesController do
  let(:default_params) { { service: 'facilities_management', framework: framework } }
  let(:framework) { 'RM3830' }
  let(:procurement_building_service) { create(:facilities_management_rm3830_procurement_building_service, procurement_building: create(:facilities_management_rm3830_procurement_building, procurement: create(:facilities_management_rm3830_procurement, user: subject.current_user))) }

  describe 'GET #edit' do
    login_fm_buyer_with_details

    context 'when logged in as the fm buyer that created the procurement' do
      it 'returns http success' do
        get :edit, params: { id: procurement_building_service.id, service_question: 'lifts' }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when logged in as a different fm buyer than the one that created the procurement' do
      it 'redirects to not permitted page' do
        procurement_building_service.procurement_building.procurement.update(user: create(:user))
        get :edit, params: { id: procurement_building_service.id }
        expect(response).to redirect_to '/facilities-management/RM3830/not-permitted'
      end
    end

    context 'when the step is not recognised' do
      it 'redirects to the procurement buildings page' do
        get :edit, params: { id: procurement_building_service.id, service_question: 'elavator' }

        expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
      end
    end

    context 'when on the show page' do
      it 'renders the edit page' do
        get :edit, params: { id: procurement_building_service.id, service_question: 'lifts' }

        expect(response).to render_template('edit')
      end
    end

    context 'when logging in without buyer details' do
      login_fm_buyer

      it 'is expected to redirect to edit_facilities_management_buyer_detail_path' do
        get :edit, params: { id: procurement_building_service.id }

        expect(response).to redirect_to edit_facilities_management_buyer_detail_path(framework, controller.current_user.buyer_detail)
      end
    end
  end

  describe 'PATCH update' do
    login_fm_buyer_with_details

    before do
      procurement_building_service.procurement_building.procurement.update(aasm_state: 'detailed_search')
    end

    context 'when updating lift data' do
      before do
        procurement_building_service.update(code: 'C.5')
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'lifts', lifts_attributes: { '0': { number_of_floors: lifts[0], _destroy: false }, '1': { number_of_floors: lifts[1], _destroy: false }, '2': { number_of_floors: lifts[2], _destroy: false }, '3': { number_of_floors: lifts[3], _destroy: false } } } }
      end

      context 'when the lift data is valid' do
        let(:lifts) { [10, 13, 7, 6] }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
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
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'service_hours', service_hours: service_hours, detail_of_requirement: detail_of_requirement } }
      end

      context 'when the service hour data is valid' do
        let(:service_hours) { 506 }
        let(:detail_of_requirement) { 'Detail of the requirement' }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
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
          patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'service_hours', service_hours: service_hours, detail_of_requirement: detail_of_requirement } }

          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating no_of_appliances_for_testing data' do
      before do
        procurement_building_service.update(code: 'E.4')
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'volumes', no_of_appliances_for_testing: no_of_appliances_for_testing } }
      end

      context 'when the no_of_appliances_for_testing data is valid' do
        let(:no_of_appliances_for_testing) { 506 }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
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
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'volumes', tones_to_be_collected_and_removed: tones_to_be_collected_and_removed } }
      end

      context 'when the tones_to_be_collected_and_removed data is valid' do
        let(:tones_to_be_collected_and_removed) { 1000 }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
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
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'volumes', no_of_units_to_be_serviced: no_of_units_to_be_serviced } }
      end

      context 'when the no_of_units_to_be_serviced data is valid' do
        let(:no_of_units_to_be_serviced) { 350 }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
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

    context 'when updating no_of_consoles_to_be_serviced data' do
      before do
        procurement_building_service.update(code: 'K.1')
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'volumes', no_of_consoles_to_be_serviced: no_of_consoles_to_be_serviced } }
      end

      context 'when the no_of_consoles_to_be_serviced data is valid' do
        let(:no_of_consoles_to_be_serviced) { 340 }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the no_of_consoles_to_be_serviced data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.no_of_consoles_to_be_serviced).to eq no_of_consoles_to_be_serviced
        end
      end

      context 'when the no_of_consoles_to_be_serviced is not valid' do
        let(:no_of_consoles_to_be_serviced) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating no_of_building_occupants data' do
      before do
        procurement_building_service.update(code: 'G.3')
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'volumes', no_of_building_occupants: no_of_building_occupants } }
      end

      context 'when the no_of_building_occupants data is valid' do
        let(:no_of_building_occupants) { 150 }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the no_of_building_occupants data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.no_of_building_occupants).to eq no_of_building_occupants
        end
      end

      context 'when the no_of_building_occupants is not valid' do
        let(:no_of_building_occupants) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating service standards for routine cleaning' do
      before do
        procurement_building_service.update(code: 'G.1')
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'service_standards', service_standard: service_standard } }
      end

      context 'when the routine cleaning data is valid' do
        let(:service_standard) { 'A' }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the routine cleaning service standards data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.service_standard).to eq service_standard
        end
      end

      context 'when the routine cleaning service standards is not valid' do
        let(:service_standard) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating service standards for building and fabric maintenance' do
      before do
        procurement_building_service.update(code: 'C.7')
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'service_standards', service_standard: service_standard } }
      end

      context 'when the building and fabric maintenance data is valid' do
        let(:service_standard) { 'B' }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the building and fabric maintenance service standards data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.service_standard).to eq service_standard
        end
      end

      context 'when the building and fabric maintenance service standards is not valid' do
        let(:service_standard) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    context 'when updating service standards for mechanical and electrical engineering maintenance' do
      before do
        procurement_building_service.update(code: 'C.7')
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'service_standards', service_standard: service_standard } }
      end

      context 'when the mechanical and electrical engineering maintenance data is valid' do
        let(:service_standard) { 'C' }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
        end

        it 'updates the mechanical and electrical engineering maintenance service standards data correctly' do
          procurement_building_service.reload
          expect(procurement_building_service.service_standard).to eq service_standard
        end
      end

      context 'when the mechanical and electrical engineering maintenance service standards is not valid' do
        let(:service_standard) { nil }

        it 'renders the edit page' do
          expect(response).to render_template('edit')
        end
      end
    end

    # rubocop:disable RSpec/NestedGroups
    context 'when updating the building areas' do
      let(:code) { 'C.1' }
      let(:gia) { 100 }
      let(:external_area) { 100 }
      let(:codes) { [code] }

      before do
        procurement_building_service.procurement_building.update(service_codes: codes)
        procurement_building_service.update(code:)
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: 'area' }, facilities_management_building: { gia:, external_area: } }
      end

      context 'when the area updated is invalid' do
        context 'when gia is nil' do
          let(:gia) { nil }

          it 'renders the edit template' do
            expect(response).to render_template('edit')
          end
        end

        context 'when external_area is nil' do
          let(:external_area) { nil }

          it 'renders the edit template' do
            expect(response).to render_template('edit')
          end
        end

        context 'when both gia and external_area is 0' do
          let(:gia) { 0 }
          let(:external_area) { 0 }

          it 'renders the edit template' do
            expect(response).to render_template('edit')
          end
        end
      end

      context 'when gia is 0 but there is a service which requires it' do
        let(:gia) { 0 }

        it 'renders the edit template' do
          expect(response).to render_template('edit')
        end

        it 'has the correct error message' do
          expect(assigns(:building).errors[:gia].first).to eq 'Gross Internal Area (GIA) must be greater than 0'
        end
      end

      context 'when external_area is 0 but there is a service which requires it' do
        let(:external_area) { 0 }
        let(:code) { 'G.5' }

        it 'renders the edit template' do
          expect(response).to render_template('edit')
        end

        it 'has the correct error message' do
          expect(assigns(:building).errors[:external_area].first).to eq 'External area must be greater than 0'
        end
      end

      context 'when the gia and external area are not 0' do
        let(:code) { 'G.5' }
        let(:codes) { ['C.1', 'G.5'] }

        it 'redirects to facilities_management_rm3830_procurement_building_path' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end

    context 'when updating neither lift or service hour data' do
      it 'redirects to facilities_management_rm3830_procurement_building_path' do
        patch :update, params: { id: procurement_building_service.id, facilities_management_rm3830_procurement_building_service: { service_question: nil } }

        expect(response).to redirect_to facilities_management_rm3830_procurement_building_path(procurement_building_service.procurement_building)
      end
    end
  end
end
