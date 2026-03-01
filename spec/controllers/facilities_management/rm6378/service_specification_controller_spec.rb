require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::ServiceSpecificationController do
  let(:default_params) { { service: 'facilities_management', framework: 'RM6378' } }

  describe 'GET show' do
    context 'when the user is not signed in' do
      it 'redirects to the sign in page' do
        get :show, params: { service_code: 'C.1' }

        expect(response).to redirect_to facilities_management_rm6378_new_user_session_path
      end
    end

    context 'when checking the page renders for all service numbers' do
      login_fm_buyer_with_details

      service_codes = Service.where("id LIKE 'RM6378%'").distinct(:number).pluck(:number)

      service_codes.each do |service_code|
        context "and the service number is #{service_code}" do
          before { get :show, params: { service_code: } }

          it 'renders the show page successfully' do
            expect(response).to render_template(:show)
          end
        end
      end
    end
  end
end
