require 'rails_helper'

RSpec.describe HomeController, type: :controller, auth: true do
  describe 'GET gateway' do
    context 'when not signed in' do
      it 'renders the gateway page' do
        allow(controller).to receive(:logged_in?).and_return(false)
        get :gateway
        expect(response).to render_template(:gateway)
      end
    end

    context 'when signed in' do
      it 'redirects to the start page' do
        allow(controller).to receive(:logged_in?).and_return(true)
        get :gateway
        expect(response).to redirect_to(homepage_path)
      end
    end
  end

  describe 'GET status' do
    it 'displays status information about the app' do
      get :status

      expect(response).to render_template(:status, layout: false)
    end
  end
end
