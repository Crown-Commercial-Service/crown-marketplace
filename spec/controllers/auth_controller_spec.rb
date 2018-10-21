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
end
