require 'rails_helper'

RSpec.describe FacilitiesManagement::SelectLocationsController, type: :controller do

  describe "GET #select_location" do
    it "returns http success" do
      get :select_location
      expect(response).to have_http_status(:success)
    end
  end

end
