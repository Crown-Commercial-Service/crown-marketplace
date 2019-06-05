require 'rails_helper'

RSpec.describe LegalServices::HomeController, type: :controller do
  login_ls_buyer
  describe 'GET index' do
    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end
  end
end
