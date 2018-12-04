require 'rails_helper'

RSpec.describe HomeController, type: :controller, auth: true do
  let(:logged_in) { true }

  before do
    allow(controller).to receive(:logged_in?).and_return(logged_in)
  end

  describe 'GET status' do
    context 'when not signed in' do
      let(:logged_in) { false }

      it 'displays status information about the app' do
        get :status
        expect(response).to render_template(:status, layout: false)
      end
    end

    context 'when signed in' do
      let(:logged_in) { true }

      it 'displays status information about the app' do
        get :status
        expect(response).to render_template(:status, layout: false)
      end
    end
  end
end
