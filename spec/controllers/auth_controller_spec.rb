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

    it 'redirects to the homepage' do
      get :callback
      expect(response).to redirect_to(homepage_path)
    end
  end

  describe 'POST #logout' do
    it 'deletes the email from the session' do
      session[:userinfo] = 'user@example.com'
      post :logout
      expect(session[:userinfo]).to be_nil
    end

    it 'redirects to the Cognito logout path' do
      post :logout
      expect(response).to redirect_to(Cognito.logout_path(gateway_url))
    end
  end
end
