require 'rails_helper'

RSpec.describe TempToPermCalculator::JourneyController, type: :controller do
  describe 'GET #start for temp-to-perm-calculator' do
    it 'redirects to the first step in the journey' do
      get :start, params: {
        journey: 'temp-to-perm-calculator'
      }

      expect(response).to redirect_to(
        journey_question_path(journey: 'temp-to-perm-calculator', slug: 'contract-start')
      )
    end
  end
end
