require 'rails_helper'

RSpec.describe FacilitiesManagement::HomeController do
  let(:default_params) { { service: 'facilities_management' } }

  describe 'GET framework' do
    context 'when RM6232 is live in the future' do
      include_context 'and RM6232 is not live'

      it 'redirects to the RM3830 home page' do
        get :framework
        expect(response).to redirect_to facilities_management_rm3830_path
      end

      context 'when the user is logged in without details' do
        login_fm_buyer

        it 'redirects to the RM3830 home page' do
          get :framework
          expect(response).to redirect_to facilities_management_rm3830_path
        end
      end
    end

    context 'when RM6232 is live' do
      it 'redirects to the RM6232 home page' do
        get :framework
        expect(response).to redirect_to facilities_management_rm6232_path
      end

      context 'when the user is logged in without details' do
        login_fm_buyer

        it 'redirects to the RM6232 home page' do
          get :framework
          expect(response).to redirect_to facilities_management_rm6232_path
        end
      end
    end
  end

  describe 'GET index' do
    context 'when RM6232 is live in the future' do
      include_context 'and RM6232 is not live'

      it 'renders the unrecognised framework page with the right http status' do
        get :index, params: { framework: 'RM6232' }

        expect(response).to render_template('home/unrecognised_framework')
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when RM6232 is live' do
      # This is because in practice, the rails router will have already used the correct framework controller,
      # therefore, this test is just to make sure that the UnrecognisedLiveFrameworkError is not invoked
      it 'raises the MissingExactTemplate error' do
        expect do
          get :index, params: { framework: 'RM6232' }
        end.to raise_error(ActionController::MissingExactTemplate)
      end
    end
  end
end
