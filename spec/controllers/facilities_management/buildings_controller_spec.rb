require 'rails_helper'

RSpec.describe FacilitiesManagement::BuildingsController, type: :controller do

  describe "GET #buildings" do
    it "returns http success" do
      get :buildings
      expect(response).to have_http_status(:success)
    end
  end

end
