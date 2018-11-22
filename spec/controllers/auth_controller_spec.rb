require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe 'GET #callback' do
    it 'stores the email in the session' do
      request.env['omniauth.auth'] = {
        'info' => {
          'email' => 'user@example.com'
        }
      }
      get :callback
      expect(session[:userinfo]).to eq('user@example.com')
    end

    it 'stores the provider in the session' do
      request.env['omniauth.auth'] = {
        'provider' => :auth_provider
      }
      get :callback
      expect(session[:auth_provider]).to eq(:auth_provider)
    end

    it 'redirects to the homepage' do
      get :callback
      expect(response).to redirect_to(homepage_path)
    end
  end

  describe 'POST #sign_out' do
    it 'deletes the email from the session' do
      session[:userinfo] = 'user@example.com'
      post :sign_out
      expect(session[:userinfo]).to be_nil
    end

    context 'when signed in using cognito' do
      before do
        session[:auth_provider] = :cognito
      end

      it 'redirects to the Cognito logout path' do
        post :sign_out
        expect(response).to redirect_to(Cognito.logout_path(gateway_url))
      end
    end

    context 'when signed in using dfe signin' do
      before do
        session[:auth_provider] = :dfe
      end

      it 'redirects to the home page' do
        post :sign_out
        expect(response).to redirect_to(homepage_path)
      end
    end
  end
end
