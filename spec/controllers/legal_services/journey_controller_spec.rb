require 'rails_helper'

RSpec.describe LegalServices::JourneyController, type: :controller, auth: true do
  before do
    permit_framework :legal_services
  end

  describe 'GET #start' do
    it 'redirects to the first step in the journey' do
      get :start, params: {
        journey: 'legal-services'
      }

      expect(response).to redirect_to(
        journey_question_path(journey: 'legal-services', slug: 'choose-organisation-type')
      )
    end
  end

  describe 'GET #choose-organisation-type' do
    it 'renders template' do
      get :question, params: {
        journey: 'legal-services',
        slug: 'choose-organisation-type'
      }

      expect(response).to render_template('choose_organisation_type')
    end
  end

  describe 'GET #check-suitability' do
    it 'renders template' do
      get :question, params: {
        journey: 'legal-services',
        slug: 'check-suitability',
        central_government: 'yes'
      }

      expect(response).to render_template('check_suitability')
    end
  end

  describe 'GET #choose-services-area' do
    it 'renders template' do
      get :question, params: {
        journey: 'legal-services',
        slug: 'choose-services-area',
        central_government: 'no'
      }

      expect(response).to render_template('choose_services_area')
    end
  end
end
