require 'rails_helper'
RSpec.describe FacilitiesManagement::StandardContractQuestionsController, type: :controller do
  describe 'GET #standard_contract_questions' do
    it 'returns http success' do
      get :standard_contract_questions
      expect(response).to have_http_status(:found)
    end
  end
end
