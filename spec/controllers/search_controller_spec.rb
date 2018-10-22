require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET hire_via_agency_question' do
    context 'when not logged in' do
      before do
        ensure_not_logged_in
      end

      it 'redirects to gateway page' do
        expect(get(:hire_via_agency_answer)).to redirect_to(gateway_path)
      end
    end

    it 'renders template' do
      ensure_logged_in
      get :hire_via_agency_question
      expect(response).to render_template('hire_via_agency_question')
    end
  end

  describe 'GET hire_via_agency_answer' do
    before do
      ensure_logged_in
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
      ensure_logged_in
      get :managed_service_provider_question
      expect(response).to render_template('managed_service_provider_question')
    end
  end

  describe 'GET managed_service_provider_answer' do
    before do
      ensure_logged_in
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
      ensure_logged_in
      get :nominated_worker_question
      expect(response).to render_template('nominated_worker_question')
    end
  end

  describe 'GET nominated_worker_answer' do
    let(:params) do
      {
        hire_via_agency: 'yes',
        nominated_worker: nominated_worker
      }
    end

    before do
      ensure_logged_in
      get :nominated_worker_answer, params: params
    end

    context 'when nominated worker is yes' do
      let(:nominated_worker) { 'yes' }

      it 'redirects to non nominated worker outcome' do
        expect(response).to redirect_to(
          school_postcode_question_path(params)
        )
      end
    end

    context 'when nominated worker is no' do
      let(:nominated_worker) { 'no' }

      it 'redirects to school payroll question path' do
        expect(response).to redirect_to(
          school_payroll_question_path(params)
        )
      end
    end

    context 'when nominated worker is blank' do
      let(:nominated_worker) { '' }

      it 'redirects to nominated worker question' do
        expect(response).to redirect_to(
          nominated_worker_question_path(params)
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
          nominated_worker_question_path(params)
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET school_postcode_question' do
    before do
      ensure_logged_in
    end

    it 'renders template' do
      get :school_postcode_question
      expect(response).to render_template('school_postcode_question')
    end

    it 'sets back_path to nominated worker question including params' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'yes'
      }
      get :school_postcode_question, params: params
      expect(assigns(:back_path)).to eq(nominated_worker_question_path(params))
    end

    it 'sets form_path to school postcode answer path' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'yes'
      }
      get :school_postcode_question, params: params
      expect(assigns(:form_path)).to eq(school_postcode_answer_path)
    end

    it 'sets back path to school payroll question if employing worker on school payroll' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no',
        school_payroll: 'yes'
      }
      get :school_postcode_question, params: params
      expect(assigns(:back_path)).to eq(school_payroll_question_path(params))
    end
  end

  describe 'GET school_postcode_answer' do
    let(:postcode) { Faker::Address.unique.postcode }

    before do
      ensure_logged_in
    end

    it 'redirects to branches path' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no',
        school_payroll: 'yes',
        postcode: postcode
      }
      get :school_postcode_answer, params: params
      expect(response).to redirect_to(branches_path(params))
    end
  end

  describe 'GET master_vendor_managed_service_outcome' do
    before do
      ensure_logged_in
    end

    it 'redirects to master vendor managed service providers path' do
      params = {
        hire_via_agency: 'no',
        master_vendor: 'yes'
      }
      get :master_vendor_managed_service_outcome, params: params
      expect(response).to redirect_to(master_vendor_managed_service_providers_path(params))
    end
  end

  describe 'GET neutral_vendor_managed_service_outcome' do
    before do
      ensure_logged_in
    end

    it 'renders template' do
      get :neutral_vendor_managed_service_outcome
      expect(response).to render_template('neutral_vendor_managed_service_outcome')
    end
  end

  describe 'GET school_payroll_question' do
    before do
      ensure_logged_in
    end

    it 'sets the form path to school payroll answer' do
      get :school_payroll_question
      expect(assigns(:form_path)).to eq(school_payroll_answer_path)
    end

    it 'sets the back path to the nominated worker question' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no'
      }
      get :school_payroll_question, params: params
      expect(assigns(:back_path)).to eq(nominated_worker_question_path(params))
    end
  end

  describe 'GET school_payroll_answer' do
    before do
      ensure_logged_in
    end

    context 'when the answer is yes' do
      it 'redirects to postcode form' do
        params = {
          hire_via_agency: 'yes',
          nominated_worker: 'no',
          school_payroll: 'yes'
        }
        get :school_payroll_answer, params: params
        expect(response).to redirect_to(school_postcode_question_path(params))
      end
    end

    context 'when the answer is no' do
      it 'redirects to agency payroll outcome' do
        params = {
          hire_via_agency: 'yes',
          nominated_worker: 'no',
          school_payroll: 'no'
        }
        get :school_payroll_answer, params: params
        expect(response).to redirect_to(agency_payroll_outcome_path(params))
      end
    end

    context 'when the answer is blank' do
      let(:params) do
        {
          hire_via_agency: 'yes',
          nominated_worker: 'no',
          school_payroll: ''
        }
      end

      before do
        get :school_payroll_answer, params: params
      end

      it 'redirects to school payroll question' do
        expect(response).to redirect_to(school_payroll_question_path(params))
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET agency_payroll_outcome' do
    before do
      ensure_logged_in
    end

    it 'sets the back link to the school payroll question' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no',
        school_payroll: 'no'
      }
      get :agency_payroll_outcome, params: params
      expect(assigns(:back_path)).to eq(school_payroll_question_path(params))
    end
  end
end
