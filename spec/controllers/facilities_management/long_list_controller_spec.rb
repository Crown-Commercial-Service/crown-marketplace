require 'rails_helper'

RSpec.describe FacilitiesManagement::LongListController, type: :controller do

  describe "GET #longList" do
    it "returns http success" do
      get :longList
      expect(response).to have_http_status(:success)
    end
  end

end
