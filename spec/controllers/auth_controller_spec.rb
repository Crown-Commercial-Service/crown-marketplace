require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  let(:current_login) { controller.instance_eval { current_login } }

  describe 'GET #callback' do
    before do
      request.env['omniauth.auth'] = {
        'info' => {
          'email' => 'user@example.com'
        },
        'provider' => 'cognito'
      }

      controller.instance_eval do
        session[:requested_path] = '/REQUESTED'
      end
    end

    it 'stores the email in the session' do
      get :callback
      expect(current_login.email).to eq('user@example.com')
    end

    it 'redirects to the page stored in the session' do
      get :callback
      expect(response).to redirect_to('/REQUESTED')
    end
  end

  describe 'POST #sign_out' do
    before do
      controller.instance_eval do
        self.current_login = Login::CognitoLogin.new(email: 'user@example.com', extra: {})
      end
    end

    context 'when signed in using cognito' do
      context 'when the last visited framework was facilities management' do
        before do
          controller.instance_eval do
            session[:last_visited_framework] = 'facilities_management'
          end
        end

        it 'redirects to the Cognito logout path for the framework' do
          post :sign_out
          expect(response).to redirect_to(Cognito.logout_url(facilities_management_gateway_url))
        end
      end

      context 'when the last visited framework was management consultancy' do
        before do
          controller.instance_eval do
            session[:last_visited_framework] = 'management_consultancy'
          end
        end

        it 'redirects to the Cognito logout path for the framework' do
          post :sign_out
          expect(response).to redirect_to(Cognito.logout_url(management_consultancy_gateway_url))
        end
      end

      context 'when the last visited framework was supply teachers' do
        before do
          controller.instance_eval do
            session[:last_visited_framework] = 'supply_teachers'
          end
        end

        it 'redirects to the Cognito logout path for the framework' do
          post :sign_out
          expect(response).to redirect_to(Cognito.logout_url(supply_teachers_gateway_url))
        end
      end

      it 'deletes the login from the session' do
        post :sign_out
        expect(current_login).to be_nil
      end
    end

    context 'when signed in using dfe signin' do
      before do
        controller.instance_eval do
          self.current_login = Login::DfeLogin.new(email: 'user@example.com', extra: {})
        end
      end

      it 'redirects to the supply teachers start page' do
        post :sign_out
        expect(response).to redirect_to(supply_teachers_gateway_url)
      end

      it 'deletes the login from the session' do
        post :sign_out
        expect(current_login).to be_nil
      end
    end

    context 'when there is no valid current_login (fallback)' do
      before do
        session.delete :login
      end

      it 'redirects to the supply teachers start page' do
        post :sign_out
        expect(response).to redirect_to(controller.gateway_url)
      end
    end
  end
end
