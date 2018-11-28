require 'rails_helper'

RSpec.describe AuthController, type: :controller do
  describe 'GET #callback' do
    before do
      request.env['omniauth.auth'] = {
        'info' => {
          'email' => 'user@example.com'
        },
        'provider' => 'cognito'
      }
    end

    it 'stores the email in the session' do
      get :callback
      expect(subject.current_login.email).to eq('user@example.com')
    end

    it 'redirects to the homepage' do
      get :callback
      expect(response).to redirect_to(homepage_path)
    end
  end

  describe 'POST #sign_out' do
    before do
      subject.current_login = Login::CognitoLogin.new(email: 'user@example.com', extra: {})
    end

    context 'when signed in using cognito' do
      it 'redirects to the Cognito logout path' do
        post :sign_out
        expect(response).to redirect_to(Cognito.logout_path(gateway_url))
      end

      it 'deletes the login from the session' do
        post :sign_out
        expect(subject.current_login).to be_nil
      end
    end

    context 'when signed in using dfe signin' do
      before do
        subject.current_login = Login::DfeLogin.new(email: 'user@example.com', extra: {})
      end

      it 'redirects to the home page' do
        post :sign_out
        expect(response).to redirect_to(homepage_path)
      end

      it 'deletes the login from the session' do
        post :sign_out
        expect(subject.current_login).to be_nil
      end
    end
  end
end
