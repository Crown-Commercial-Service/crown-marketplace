require 'rails_helper'

RSpec.describe FacilitiesManagement::HomeController do
  let(:default_params) { { service: 'facilities_management' } }

  describe 'GET framework' do
    it 'redirects to the RM6378 home page' do
      get :framework
      expect(response).to redirect_to facilities_management_index_path('RM6378')
    end

    context 'when RM6232 is still live and RM6378 is not' do
      include_context 'and RM6232 is live'
      include_context 'and RM6378 is live in the future'

      it 'redirects to the RM6232 home page' do
        get :framework
        expect(response).to redirect_to '/facilities-management/RM6232'
      end
    end
  end

  describe 'GET index' do
    context 'when RM6378 is live' do
      context 'and the framework is not RM6232 or RM6378' do
        it 'renders the unrecognised framework page with the right http status' do
          get :index, params: { framework: 'RM3826' }

          expect(response).to render_template('facilities_management/home/unrecognised_framework')
          expect(response).to have_http_status(:bad_request)
        end
      end

      # This is because in practice, the rails router will have already used the correct framework controller,
      # therefore, this test is just to make sure that the UnrecognisedLiveFrameworkError is not invoked
      context 'and the framework is RM6378' do
        it 'raises the MissingExactTemplate error' do
          expect do
            get :index, params: { framework: 'RM6378' }
          end.to raise_error(ActionController::MissingExactTemplate)
        end
      end

      context 'and the framework is RM6232' do
        it 'renders the unrecognised framework page with the right http status' do
          get :index, params: { framework: 'RM6232' }

          expect(response).to render_template('facilities_management/home/unrecognised_framework')
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when RM6378 is not live' do
      include_context 'and RM6378 is live in the future'

      context 'and the framework is not RM6232 or RM6378' do
        it 'renders the unrecognised framework page with the right http status' do
          get :index, params: { framework: 'RM3826' }

          expect(response).to render_template('facilities_management/home/unrecognised_framework')
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'and the framework is RM6378' do
        it 'renders the unrecognised framework page with the right http status' do
          get :index, params: { framework: 'RM6378' }

          expect(response).to render_template('facilities_management/home/unrecognised_framework')
          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'and the framework is RM6232' do
        it 'renders the unrecognised framework page with the right http status' do
          get :index, params: { framework: 'RM6232' }

          expect(response).to render_template('facilities_management/home/unrecognised_framework')
          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end

  describe 'validate service' do
    context 'when the service is not a valid service' do
      let(:default_params) { { service: 'apprenticeships' } }

      it 'renders the erros_not_found page' do
        get :framework

        expect(response).to redirect_to errors_404_path
      end
    end
  end
end
