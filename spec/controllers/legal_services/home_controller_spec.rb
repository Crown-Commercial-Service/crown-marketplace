require 'rails_helper'

RSpec.describe LegalServices::HomeController, type: :controller, auth: true do
  before do
    permit_framework :legal_services
  end

  describe 'GET index' do
    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end
  end
end
