require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET hire_via_agency_question' do
    it 'renders template' do
      get :hire_via_agency_question
      expect(response).to render_template('hire_via_agency_question')
    end
  end

  describe 'GET hire_via_agency_answer' do
    before do
      get :hire_via_agency_answer, params: { hire_via_agency: hire_via_agency }
    end

    context 'when hire via agency is yes' do
      let(:hire_via_agency) { 'yes' }

      it 'redirects to nominated worker question' do
        expect(response).to redirect_to(
          nominated_worker_question_path(hire_via_agency: 'yes')
        )
      end
    end

    context 'when hire via agency is no' do
      let(:hire_via_agency) { 'no' }

      it 'redirects to managed service providers outcome' do
        expect(response).to redirect_to(
          managed_service_provider_question_path(hire_via_agency: 'no')
        )
      end
    end

    context 'when hire via agency is blank' do
      let(:hire_via_agency) { '' }

      it 'redirects to hire via agency question' do
        expect(response).to redirect_to(
          hire_via_agency_question_path(hire_via_agency: '')
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET managed_service_provider_question' do
    it 'renders template' do
      get :managed_service_provider_question
      expect(response).to render_template('managed_service_provider_question')
    end
  end

  describe 'GET managed_service_provider_answer' do
    before do
      get :managed_service_provider_answer, params: {
        master_vendor: master_vendor,
        hire_via_agency: 'no'
      }
    end

    context 'when master vendor is yes' do
      let(:master_vendor) { 'yes' }

      it 'redirects to master vendor managed service outcome' do
        expect(response).to redirect_to(
          master_vendor_managed_service_outcome_path(
            master_vendor: master_vendor,
            hire_via_agency: 'no'
          )
        )
      end
    end

    context 'when master vendor is no' do
      let(:master_vendor) { 'no' }

      it 'redirects to neutral vendor managed service outcome' do
        expect(response).to redirect_to(
          neutral_vendor_managed_service_outcome_path(
            master_vendor: master_vendor,
            hire_via_agency: 'no'
          )
        )
      end
    end

    context 'when master vendor is blank' do
      let(:master_vendor) { '' }

      it 'redirects to managed service provider question' do
        expect(response).to redirect_to(
          managed_service_provider_question_path(
            master_vendor: '',
            hire_via_agency: 'no'
          )
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET nominated_worker_question' do
    it 'renders template' do
      get :nominated_worker_question
      expect(response).to render_template('nominated_worker_question')
    end
  end

  describe 'GET nominated_worker_answer' do
    before do
      get :nominated_worker_answer, params: { nominated_worker: nominated_worker }
    end

    context 'when nominated worker is yes' do
      let(:nominated_worker) { 'yes' }

      it 'redirects to non nominated worker outcome' do
        expect(response).to redirect_to(
          school_postcode_question_path(nominated_worker: 'yes')
        )
      end
    end

    context 'when nominated worker is no' do
      let(:nominated_worker) { 'no' }

      it 'redirects to non nominated worker outcome' do
        expect(response).to redirect_to(
          non_nominated_worker_outcome_path(nominated_worker: 'no')
        )
      end
    end

    context 'when nominated worker is blank' do
      let(:nominated_worker) { '' }

      it 'redirects to nominated worker question' do
        expect(response).to redirect_to(
          nominated_worker_question_path(nominated_worker: '')
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end

    context 'when nominated worker is unknown' do
      let(:nominated_worker) { 'blahblah' }

      it 'redirects to nominated worker question' do
        expect(response).to redirect_to(
          nominated_worker_question_path(nominated_worker: 'blahblah')
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET school_postcode_question' do
    it 'renders template' do
      get :school_postcode_question
      expect(response).to render_template('school_postcode_question')
    end
  end

  describe 'GET school_postcode_answer' do
    let(:postcode) { Faker::Address.unique.postcode }

    it 'redirects to branches with postcode and nominated_worker' do
      get :school_postcode_answer, params: {
        postcode: postcode,
        nominated_worker: 'yes'
      }
      expect(response).to redirect_to(
        branches_path(
          postcode: postcode,
          nominated_worker: 'yes'
        )
      )
    end
  end

  describe 'GET master_vendor_managed_service_outcome' do
    it 'renders template' do
      get :master_vendor_managed_service_outcome
      expect(response).to render_template('master_vendor_managed_service_outcome')
    end
  end

  describe 'GET neutral_vendor_managed_service_outcome' do
    it 'renders template' do
      get :neutral_vendor_managed_service_outcome
      expect(response).to render_template('neutral_vendor_managed_service_outcome')
    end
  end

  describe 'GET non_nominated_worker_outcome' do
    it 'renders template' do
      get :non_nominated_worker_outcome
      expect(response).to render_template('non_nominated_worker_outcome')
    end
  end
end
