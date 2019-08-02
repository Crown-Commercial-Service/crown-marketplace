require 'rails_helper'

RSpec.describe LegalServices::JourneyController, type: :controller do
  login_ls_buyer
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

  describe 'GET #sorry' do
    it 'renders template' do
      get :question, params: {
        journey: 'legal-services',
        slug: 'sorry',
        central_government: 'yes',
        under_threshold: 'no'
      }

      expect(response).to render_template('sorry')
    end
  end

  describe 'GET #select-lot' do
    it 'renders template' do
      get :question, params: {
        journey: 'legal-services',
        slug: 'select-lot',
        central_government: 'no'
      }

      expect(response).to render_template('select_lot')
    end
  end

  describe 'GET #choose-jurisdiction' do
    it 'renders template' do
      get :question, params: {
        journey: 'legal-services',
        slug: 'choose-jurisdiction',
        central_government: 'no',
        lot: '2'
      }

      expect(response).to render_template('choose_jurisdiction')
    end
  end

  describe 'GET #choose-services' do
    context 'when buyer works for central government' do
      it 'renders template' do
        get :question, params: {
          journey: 'legal-services',
          slug: 'choose-services',
          central_government: 'yes',
          under_threshold: 'yes',
          lot: '1'
        }

        expect(response).to render_template('choose_services')
      end
    end

    context 'when buyer doesn’t work for central government' do
      it 'renders template' do
        get :question, params: {
          journey: 'legal-services',
          slug: 'choose-services',
          central_government: 'no',
          lot: '1'
        }

        expect(response).to render_template('choose_services')
      end
    end
  end

  describe 'GET #choose-regions' do
    it 'renders template' do
      get :question, params: {
        journey: 'legal-services',
        slug: 'choose-regions',
        central_government: 'no',
        lot: '1',
        services: ['WPSLS1.1']
      }

      expect(response).to render_template('choose_regions')
    end
  end
end
