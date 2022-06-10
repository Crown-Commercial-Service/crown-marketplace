require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ProcurementBuildingsController, type: :controller do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }
  let(:procurement_building) { create(:facilities_management_rm6232_procurement_building_no_services, procurement: procurement) }
  let(:procurement) { create(:facilities_management_rm6232_procurement_entering_requirements, user: user) }
  let(:user) { controller.current_user }

  login_fm_buyer_with_details

  context 'without buyer details' do
    login_fm_buyer

    it 'will redirect to buyer details' do
      get :edit, params: { procurement_id: procurement.id, id: procurement_building.id }

      expect(response).to redirect_to edit_facilities_management_buyer_detail_path(id: controller.current_user.buyer_detail.id)
    end
  end

  describe 'GET edit' do
    before { get :edit, params: { procurement_id: procurement.id, id: procurement_building.id } }

    it 'renders the edit page' do
      expect(response).to render_template(:edit)
    end

    it 'sets the procurement and procurement building' do
      expect(assigns(:procurement)).to eq procurement
      expect(assigns(:procurement_building)).to eq procurement_building
    end

    context 'when the user does not own the procurement' do
      let(:user) { create(:user) }

      it 'redirects to the not permitted path' do
        expect(response).to redirect_to facilities_management_rm6232_not_permitted_path
      end
    end
  end

  describe 'PUT update' do
    before { put :update, params: { procurement_id: procurement.id, id: procurement_building.id, facilities_management_rm6232_procurement_building: update_params } }

    context 'and the data is valid' do
      let(:update_params) { { service_codes: %w[F.1 F.2] } }

      it 'redirects to the details show page' do
        expect(response).to redirect_to facilities_management_rm6232_procurement_detail_path(procurement, 'buildings-and-services')
      end

      it 'updates service_codes' do
        expect { procurement_building.reload }.to change(procurement_building, :service_codes)

        expect(procurement_building.service_codes).to eq %w[F.1 F.2]
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
        expect(response).to redirect_to facilities_management_rm6232_procurement_detail_path(procurement, 'buildings-and-services')
      end

      it 'does no update the unpermitted attribute' do
        expect { procurement_building.reload }.not_to change(procurement_building, :active)
      end
    end
  end
end
