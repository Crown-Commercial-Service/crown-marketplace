require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::ServiceSpecificationController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6232' } }

  describe 'GET show' do
    context 'when the user is not signed in' do
      it 'redirects to the sign in page' do
        get :show, params: { service_code: 'E.1' }

        expect(response).to redirect_to facilities_management_rm6232_new_user_session_path
      end
    end

    context 'when checking the page renders for all service codes' do
      login_fm_buyer_with_details

      service_codes = FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| wp.services.order(:sort_order).pluck(:code) }.flatten

      service_codes.each do |service_code|
        context "and the service code is #{service_code}" do
          before { get :show, params: { service_code: } }

          it 'renders the show page successfully' do
            expect(response).to render_template(:show)
          end
        end
      end
    end
  end
end
