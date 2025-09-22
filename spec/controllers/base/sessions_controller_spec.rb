require 'rails_helper'

RSpec.describe Base::SessionsController do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET active' do
    context 'when the user is signed in' do
      login_fm_buyer

      before { get :active }

      it 'returns the 200 status and a body of true' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('true')
      end
    end

    context 'when the user is signed out' do
      before { get :active }

      it 'returns the 200 status and a body of false' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('false')
      end
    end
  end

  describe 'GET timeout' do
    context 'when there is no error' do
      before { get :timeout, params: { url: '/crown-marketplace/allow-list', service_path_base: service_path_base } }

      context 'and service_path_base is provided' do
        let(:service_path_base) { '/crown-marketplace' }

        it 'redirects to the service base path param sign in path' do
          expect(response).to redirect_to('/crown-marketplace/sign-in?expired=true')
        end
      end

      context 'and service_path_base is not provided' do
        let(:service_path_base) { nil }

        it 'redirects to just the sign in path' do
          expect(response).to redirect_to('/sign-in?expired=true')
        end
      end
    end

    context 'when the service_path_base would raise to a routing error' do
      before do
        allow(controller).to receive(:redirect_to).with('/facilities-management/RM7007/admin/sign-in?expired=true').and_raise(ActionController::RoutingError.new('Some error', 'Some Message'))
        allow(controller).to receive(:redirect_to).with('/facilities-management/RM6378/sign-in?expired=true').and_call_original

        get :timeout, params: { url: '/facilities-management/RM7007/admin', service_path_base: '/facilities-management/RM7007/admin' }
      end

      it 'redirects to the default sign in path' do
        expect(controller).to have_received(:redirect_to).with('/facilities-management/RM7007/admin/sign-in?expired=true')
        expect(controller).to have_received(:redirect_to).with('/facilities-management/RM6378/sign-in?expired=true')
      end
    end
  end
end
