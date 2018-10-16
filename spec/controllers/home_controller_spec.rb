require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET status' do
    it 'displays status information about the app' do
      get :status

      expect(response).to render_template(:status, layout: false)
    end
  end
end
