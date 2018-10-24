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
        looking_for: looking_for
      }
    end

    context 'when hire via agency is yes' do
      let(:looking_for) { 'worker' }

      it 'redirects to nominated worker question' do
        expect(response).to redirect_to(
          search_question_path(slug: 'nominated-worker', looking_for: 'worker')
        )
      end
    end

    context 'when hire via agency is no' do
      let(:looking_for) { 'managed_service_provider' }

      it 'redirects to managed service providers outcome' do
        expect(response).to redirect_to(
          search_question_path(slug: 'managed-service-provider', looking_for: 'managed_service_provider')
        )
      end
    end

    context 'when hire via agency is blank' do
      let(:looking_for) { '' }

      it 'redirects to hire via agency question' do
        expect(response).to redirect_to(
          search_question_path(slug: 'hire-via-agency', looking_for: '')
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
        looking_for: 'managed_service_provider'
      }
      expect(response).to render_template('managed_service_provider')
    end
  end

  describe 'GET managed_service_provider_answer' do
    before do
      get :answer, params: {
        slug: 'managed-service-provider',
        managed_service_provider: managed_service_provider,
        looking_for: 'managed_service_provider'
      }
    end

    context 'when master vendor is yes' do
      let(:managed_service_provider) { 'master_vendor' }

      it 'redirects to master vendors path' do
        expect(response).to redirect_to(
          master_vendors_path(
            managed_service_provider: managed_service_provider,
            looking_for: 'managed_service_provider'
          )
        )
      end
    end

    context 'when master vendor is no' do
      let(:managed_service_provider) { 'neutral_vendor' }

      it 'redirects to neutral vendors path' do
        expect(response).to redirect_to(
          neutral_vendors_path(
            managed_service_provider: managed_service_provider,
            looking_for: 'managed_service_provider'
          )
        )
      end
    end

    context 'when master vendor is blank' do
      let(:managed_service_provider) { '' }

      it 'redirects to managed service provider question' do
        expect(response).to redirect_to(
          search_question_path(
            slug: 'managed-service-provider',
            managed_service_provider: '',
            looking_for: 'managed_service_provider'
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
        looking_for: 'worker'
      }
      expect(response).to render_template('nominated_worker')
    end
  end

  describe 'GET nominated_worker_answer' do
    let(:params) do
      {
        looking_for: 'worker',
        worker_type: worker_type
      }
    end

    before do
      get :answer, params: params.merge(slug: 'nominated-worker')
    end

    context 'when nominated worker is yes' do
      let(:worker_type) { 'nominated' }

      it 'redirects to non nominated worker outcome' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-postcode'))
        )
      end
    end

    context 'when nominated worker is no' do
      let(:worker_type) { 'agency_supplied' }

      it 'redirects to school payroll question path' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-payroll'))
        )
      end
    end

    context 'when nominated worker is blank' do
      let(:worker_type) { '' }

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
      let(:worker_type) { 'blahblah' }

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
        looking_for: 'worker',
        worker_type: 'nominated'
      }
      expect(response).to render_template('school_postcode')
    end

    it 'sets back_path to nominated worker question including params' do
      params = {
        looking_for: 'worker',
        worker_type: 'nominated'
      }
      get :question, params: params.merge(slug: 'school-postcode')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'nominated-worker'))
      )
    end

    it 'sets form_path to school postcode answer path' do
      params = {
        looking_for: 'worker',
        worker_type: 'nominated'
      }
      get :question, params: params.merge(slug: 'school-postcode')
      expect(assigns(:form_path)).to eq(
        search_answer_path(slug: 'school-postcode')
      )
    end

    it 'sets back path to school payroll question if employing worker on school payroll' do
      params = {
        looking_for: 'worker',
        worker_type: 'agency_supplied',
        payroll_provider: 'school'
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
        looking_for: 'worker',
        worker_type: 'agency_supplied',
        payroll_provider: 'school',
        postcode: postcode
      }
      get :answer, params: params.merge(slug: 'school-postcode')
      expect(response).to redirect_to(branches_path(params))
    end
  end

  describe 'GET school_payroll_question' do
    it 'sets the form path to school payroll answer' do
      params = {
        looking_for: 'worker',
        worker_type: 'agency_supplied'
      }
      get :question, params: params.merge(slug: 'school-payroll')
      expect(assigns(:form_path)).to eq(
        search_answer_path(slug: 'school-payroll')
      )
    end

    it 'sets the back path to the nominated worker question' do
      params = {
        looking_for: 'worker',
        worker_type: 'agency_supplied'
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
          looking_for: 'worker',
          worker_type: 'agency_supplied',
          payroll_provider: 'school'
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
          looking_for: 'worker',
          worker_type: 'agency_supplied',
          payroll_provider: 'agency'
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
          looking_for: 'worker',
          worker_type: 'agency_supplied',
          payroll_provider: ''
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
        looking_for: 'worker',
        worker_type: 'agency_supplied',
        payroll_provider: 'agency'
      }
      get :question, params: params.merge(slug: 'agency-payroll')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'school-payroll'))
      )
    end
  end
end
