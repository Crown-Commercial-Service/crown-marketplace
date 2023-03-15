require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ProcurementBuildingsController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM3830' } }
  let(:procurement_building) { create(:facilities_management_rm3830_procurement_building, procurement:) }
  let(:procurement) { create(:facilities_management_rm3830_procurement, user:) }
  let(:user) { controller.current_user }

  login_fm_buyer_with_details

  context 'without buyer details' do
    login_fm_buyer

    it 'will redirect to buyer details' do
      get :show, params: { id: procurement_building.id }

      expect(response).to redirect_to edit_facilities_management_buyer_detail_path(id: controller.current_user.buyer_detail.id)
    end
  end

  describe 'GET show' do
    before do
      procurement_building.update(service_codes: %w[C.1 E.4 C.2 C.3 C.4 G.3 C.5 K.4 I.3 O.1 N.1])

      get :show, params: { id: procurement_building.id }
    end

    it 'renders the show page' do
      expect(response).to render_template(:show)
    end

    it 'assigns standards_procurement_building_services' do
      expect(assigns(:standards_procurement_building_services).map(&:code)).to eq %w[C.1 C.2 C.3 C.4 C.5 G.3]
    end

    it 'assigns volume_procurement_building_services' do
      expect(assigns(:volume_procurement_building_services).map { |service_and_context| service_and_context[:procurement_building_service].code }).to eq %w[C.1 C.2 C.3 C.4 C.5 E.4 G.3 G.3 I.3 K.4]
    end

    context 'when the user does not own the procurement' do
      let(:user) { create(:user) }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
      end
    end
  end

  describe 'GET edit' do
    before { get :edit, params: { id: procurement_building.id, section: section_name } }

    context 'when the edit page is not recognised' do
      let(:section_name) { 'services-and-buildings' }

      it 'redirects to the procurement show page' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
      end
    end

    context 'when the user does not own the procurement' do
      let(:section_name) { 'services-and-buildings' }
      let(:user) { create(:user) }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
      end
    end

    context 'when the user wants to assign buildings and services' do
      let(:section_name) { 'buildings-and-services' }

      render_views

      it 'renders the buildings_and_services partial' do
        expect(response).to render_template(partial: '_buildings_and_services')
      end

      it 'sets the procurement, procurement building and building' do
        expect(assigns(:procurement)).to eq procurement
        expect(assigns(:procurement_building)).to eq procurement_building
        expect(assigns(:building)).to eq procurement_building.building
      end
    end

    context 'when the user wants to edit the missing region' do
      let(:section_name) { 'missing_region' }

      render_views

      it 'renders the missing_region partial' do
        expect(response).to render_template(partial: '_missing_region')
      end

      it 'sets the procurement, procurement building and building' do
        expect(assigns(:procurement)).to eq procurement
        expect(assigns(:procurement_building)).to eq procurement_building
        expect(assigns(:building)).to eq procurement_building.building
      end
    end
  end

  describe 'PUT update' do
    before { put :update, params: { id: procurement_building.id, section: section_name, model_name => update_params } }

    context 'when updating the services for the building' do
      let(:section_name) { 'buildings-and-services' }
      let(:model_name) { :facilities_management_rm3830_procurement_building }

      context 'and the data is valid' do
        let(:update_params) { { service_codes: %w[F.1 F.2] } }

        it 'redirects to the details show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_procurement_detail_path(procurement_building.procurement, section: 'buildings-and-services')
        end

        it 'updates service_codes' do
          expect { procurement_building.reload }.to change(procurement_building, :service_codes).to(%w[F.1 F.2])
        end
      end

      context 'and the data is not valid' do
        let(:update_params) { { service_codes: [''] } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update service_codes' do
          expect { procurement_building.reload }.not_to change(procurement_building, :service_codes)
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:update_params) { { service_codes: %w[F.1 F.2], active: false } }

        it 'redirects to the details show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_procurement_detail_path(procurement_building.procurement, section: 'buildings-and-services')
        end

        it 'does no update the unpermitted attribute' do
          expect { procurement_building.reload }.not_to change(procurement_building, :active)
        end
      end
    end

    context 'when updating the missing region' do
      let(:building) { procurement_building.building }
      let(:section_name) { 'missing_region' }
      let(:model_name) { :facilities_management_building }

      context 'and the data is valid' do
        let(:update_params) { { address_region: 'Tees Valley and Durham', address_region_code: 'UKC1' } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'updates regions' do
          expect { building.reload }.to(
            change(building, :address_region).to('Tees Valley and Durham')
            .and(change(building, :address_region_code).to('UKC1'))
          )
        end
      end

      context 'and the data is not valid' do
        let(:update_params) { { address_region: nil, address_region_code: nil } }

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end

        it 'does not update service_codes' do
          RSpec::Matchers.define_negated_matcher :not_change, :change

          expect { building.reload }.to(
            not_change(building, :address_region)
            .and(not_change(building, :address_region_code))
          )
        end
      end

      context 'and an unpermitted parameters are passed in' do
        let(:update_params) { { address_region: 'Tees Valley and Durham', address_region_code: 'UKC1', building_name: 'Noah' } }

        it 'redirects to the procurement show page' do
          expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
        end

        it 'does no update the unpermitted attribute' do
          expect { building.reload }.not_to change(building, :building_name)
        end
      end
    end
  end

  describe 'GET missing_regions' do
    let(:building) { create(:facilities_management_building, user:, **building_params) }
    let(:procurement_building) { create(:facilities_management_rm3830_procurement_building_no_services, procurement:, building:) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_entering_requirements, user: user, procurement_buildings_attributes: { '0': { building_id: building.id, active: true } }) }
    let(:building_params) { {} }

    before { get :missing_regions, params: { procurement_id: procurement.id } }

    context 'when the user does not own the procurement' do
      let(:user) { create(:user) }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm3830_not_permitted_path
      end
    end

    context 'when there are no missing regions' do
      it 'redirects to the procurement show page' do
        expect(response).to redirect_to facilities_management_rm3830_procurement_path(procurement)
      end
    end

    context 'when there are missing regions' do
      let(:building_params) { { address_region: nil, address_region_code: nil } }

      it 'renders missing_regions' do
        expect(response).to render_template(:missing_regions)
      end

      it 'sets the procurement' do
        expect(assigns(:procurement)).to eq procurement
      end
    end
  end
end
