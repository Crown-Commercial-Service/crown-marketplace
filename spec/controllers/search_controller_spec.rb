require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET hire_via_agency_question' do
    it 'renders template' do
      get :question, params: {
        slug: 'hire-via-agency'
      }
      expect(response).to render_template('hire_via_agency')
    end
  end

  describe 'GET hire_via_agency_answer' do
    before do
      get :answer, params: {
        slug: 'hire-via-agency',
        hire_via_agency: hire_via_agency
      }
    end

    context 'when hire via agency is yes' do
      let(:hire_via_agency) { 'yes' }

      it 'redirects to nominated worker question' do
        expect(response).to redirect_to(
          search_question_path(slug: 'nominated-worker', hire_via_agency: 'yes')
        )
      end
    end

    context 'when hire via agency is no' do
      let(:hire_via_agency) { 'no' }

      it 'redirects to managed service providers outcome' do
        expect(response).to redirect_to(
          search_question_path(slug: 'managed-service-provider', hire_via_agency: 'no')
        )
      end
    end

    context 'when hire via agency is blank' do
      let(:hire_via_agency) { '' }

      it 'redirects to hire via agency question' do
        expect(response).to redirect_to(
          search_question_path(slug: 'hire-via-agency', hire_via_agency: '')
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET managed_service_provider_question' do
    it 'renders template' do
      get :question, params: {
        slug: 'managed-service-provider',
        hire_via_agency: 'no'
      }
      expect(response).to render_template('managed_service_provider')
    end
  end

  describe 'GET managed_service_provider_answer' do
    before do
      get :answer, params: {
        slug: 'managed-service-provider',
        master_vendor: master_vendor,
        hire_via_agency: 'no'
      }
    end

    context 'when master vendor is yes' do
      let(:master_vendor) { 'yes' }

      it 'redirects to master vendor managed service providers path' do
        expect(response).to redirect_to(
          master_vendor_managed_service_providers_path(
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
          search_question_path(
            slug: 'neutral-vendor-managed-service',
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
          search_question_path(
            slug: 'managed-service-provider',
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
      get :question, params: {
        slug: 'nominated-worker',
        hire_via_agency: 'yes'
      }
      expect(response).to render_template('nominated_worker')
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
      get :answer, params: params.merge(slug: 'nominated-worker')
    end

    context 'when nominated worker is yes' do
      let(:nominated_worker) { 'yes' }

      it 'redirects to non nominated worker outcome' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-postcode'))
        )
      end
    end

    context 'when nominated worker is no' do
      let(:nominated_worker) { 'no' }

      it 'redirects to school payroll question path' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-payroll'))
        )
      end
    end

    context 'when nominated worker is blank' do
      let(:nominated_worker) { '' }

      it 'redirects to nominated worker question' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'nominated-worker'))
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
          search_question_path(params.merge(slug: 'nominated-worker'))
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET school_postcode_question' do
    it 'renders template' do
      get :question, params: {
        slug: 'school-postcode',
        hire_via_agency: 'yes',
        nominated_worker: 'yes'
      }
      expect(response).to render_template('school_postcode')
    end

    it 'sets back_path to nominated worker question including params' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'yes'
      }
      get :question, params: params.merge(slug: 'school-postcode')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'nominated-worker'))
      )
    end

    it 'sets form_path to school postcode answer path' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'yes'
      }
      get :question, params: params.merge(slug: 'school-postcode')
      expect(assigns(:form_path)).to eq(
        search_answer_path(slug: 'school-postcode')
      )
    end

    it 'sets back path to school payroll question if employing worker on school payroll' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no',
        school_payroll: 'yes'
      }
      get :question, params: params.merge(slug: 'school-postcode')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'school-payroll'))
      )
    end
  end

  describe 'GET school_postcode_answer' do
    let(:postcode) { Faker::Address.unique.postcode }

    it 'redirects to branches path' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no',
        school_payroll: 'yes',
        postcode: postcode
      }
      get :answer, params: params.merge(slug: 'school-postcode')
      expect(response).to redirect_to(branches_path(params))
    end
  end

  describe 'GET neutral_vendor_managed_service_outcome' do
    it 'renders template' do
      get :question, params: {
        slug: 'neutral-vendor-managed-service',
        master_vendor: 'no',
        hire_via_agency: 'no'
      }
      expect(response).to render_template('neutral_vendor_managed_service')
    end
  end

  describe 'GET school_payroll_question' do
    it 'sets the form path to school payroll answer' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no'
      }
      get :question, params: params.merge(slug: 'school-payroll')
      expect(assigns(:form_path)).to eq(
        search_answer_path(slug: 'school-payroll')
      )
    end

    it 'sets the back path to the nominated worker question' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no'
      }
      get :question, params: params.merge(slug: 'school-payroll')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'nominated-worker'))
      )
    end
  end

  describe 'GET school_payroll_answer' do
    context 'when the answer is yes' do
      it 'redirects to postcode form' do
        params = {
          hire_via_agency: 'yes',
          nominated_worker: 'no',
          school_payroll: 'yes'
        }
        get :answer, params: params.merge(slug: 'school-payroll')
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-postcode'))
        )
      end
    end

    context 'when the answer is no' do
      it 'redirects to agency payroll outcome' do
        params = {
          hire_via_agency: 'yes',
          nominated_worker: 'no',
          school_payroll: 'no'
        }
        get :answer, params: params.merge(slug: 'school-payroll')
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'agency-payroll'))
        )
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
        get :answer, params: params.merge(slug: 'school-payroll')
      end

      it 'redirects to school payroll question' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-payroll'))
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET agency_payroll_outcome' do
    it 'sets the back link to the school payroll question' do
      params = {
        hire_via_agency: 'yes',
        nominated_worker: 'no',
        school_payroll: 'no'
      }
      get :question, params: params.merge(slug: 'agency-payroll')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'school-payroll'))
      )
    end
  end
end
