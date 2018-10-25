require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #question for looking-for' do
    it 'renders template' do
      get :question, params: {
        slug: 'looking-for'
      }
      expect(response).to render_template('looking_for')
    end
  end

  describe 'GET #answer for looking-for' do
    before do
      get :answer, params: {
        slug: 'looking-for',
        looking_for: looking_for
      }
    end

    context 'when looking to hire a worker via an agency' do
      let(:looking_for) { 'worker' }

      it 'redirects to worker-type question' do
        expect(response).to redirect_to(
          search_question_path(slug: 'worker-type', looking_for: 'worker')
        )
      end
    end

    context 'when looking to hire a managed service provider' do
      let(:looking_for) { 'managed_service_provider' }

      it 'redirects to managed service providers outcome' do
        expect(response).to redirect_to(
          search_question_path(slug: 'managed-service-provider', looking_for: 'managed_service_provider')
        )
      end
    end

    context 'when answer is blank' do
      let(:looking_for) { '' }

      it 'redirects to looking-for question' do
        expect(response).to redirect_to(
          search_question_path(slug: 'looking-for', looking_for: '')
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET #question for managed-service-provider' do
    it 'renders template' do
      get :question, params: {
        slug: 'managed-service-provider',
        looking_for: 'managed_service_provider'
      }
      expect(response).to render_template('managed_service_provider')
    end
  end

  describe 'GET #answer for managed-service-provider' do
    before do
      get :answer, params: {
        slug: 'managed-service-provider',
        managed_service_provider: managed_service_provider,
        looking_for: 'managed_service_provider'
      }
    end

    context 'when looking for a master vendor' do
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

    context 'when looking for a neutral vendor' do
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

    context 'when answer is blank' do
      let(:managed_service_provider) { '' }

      it 'redirects to managed-service-provider question' do
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

  describe 'GET #question for worker-type' do
    it 'renders template' do
      get :question, params: {
        slug: 'worker-type',
        looking_for: 'worker'
      }
      expect(response).to render_template('worker_type')
    end
  end

  describe 'GET #answer for worker-type' do
    let(:params) do
      {
        looking_for: 'worker',
        worker_type: worker_type
      }
    end

    before do
      get :answer, params: params.merge(slug: 'worker-type')
    end

    context 'when looking for a worker-type' do
      let(:worker_type) { 'nominated' }

      it 'redirects to non worker-type outcome' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-postcode'))
        )
      end
    end

    context 'when looking for an agency supplied worker' do
      let(:worker_type) { 'agency_supplied' }

      it 'redirects to payroll-provider question path' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'payroll-provider'))
        )
      end
    end

    context 'when answer is blank' do
      let(:worker_type) { '' }

      it 'redirects to worker-type question' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'worker-type'))
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end

    context 'when answer is unknown' do
      let(:worker_type) { 'blahblah' }

      it 'redirects to worker-type question' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'worker-type'))
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET #question for school-postcode' do
    it 'renders template' do
      get :question, params: {
        slug: 'school-postcode',
        looking_for: 'worker',
        worker_type: 'nominated'
      }
      expect(response).to render_template('school_postcode')
    end

    it 'sets back_path to worker-type question including params' do
      params = {
        looking_for: 'worker',
        worker_type: 'nominated'
      }
      get :question, params: params.merge(slug: 'school-postcode')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'worker-type'))
      )
    end

    it 'sets form_path to school-postcode answer path' do
      params = {
        looking_for: 'worker',
        worker_type: 'nominated'
      }
      get :question, params: params.merge(slug: 'school-postcode')
      expect(assigns(:form_path)).to eq(
        search_answer_path(slug: 'school-postcode')
      )
    end

    it 'sets back path to payroll-provider question if employing worker on school payroll' do
      params = {
        looking_for: 'worker',
        worker_type: 'agency_supplied',
        payroll_provider: 'school'
      }
      get :question, params: params.merge(slug: 'school-postcode')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'payroll-provider'))
      )
    end
  end

  describe 'GET #answer for school-postcode' do
    let(:postcode) { Faker::Address.unique.postcode }

    before do
      Geocoder::Lookup::Test.add_stub(
        postcode, [{ 'coordinates' => [51.5149666, -0.119098] }]
      )
    end

    it 'redirects to fixed term results path' do
      params = {
        looking_for: 'worker',
        worker_type: 'agency_supplied',
        payroll_provider: 'school',
        postcode: postcode
      }
      get :answer, params: params.merge(slug: 'school-postcode')
      expect(response).to redirect_to(fixed_term_results_path(params))
    end
  end

  describe 'GET #question for payroll-provider' do
    it 'sets the form path to payroll-provider answer' do
      params = {
        looking_for: 'worker',
        worker_type: 'agency_supplied'
      }
      get :question, params: params.merge(slug: 'payroll-provider')
      expect(assigns(:form_path)).to eq(
        search_answer_path(slug: 'payroll-provider')
      )
    end

    it 'sets the back path to the worker-type question' do
      params = {
        looking_for: 'worker',
        worker_type: 'agency_supplied'
      }
      get :question, params: params.merge(slug: 'payroll-provider')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'worker-type'))
      )
    end
  end

  describe 'GET #answer for payroll-provider' do
    context 'when looking for the school to provide payroll' do
      it 'redirects to postcode form' do
        params = {
          looking_for: 'worker',
          worker_type: 'agency_supplied',
          payroll_provider: 'school'
        }
        get :answer, params: params.merge(slug: 'payroll-provider')
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'school-postcode'))
        )
      end
    end

    context 'when looking for the agency to provide payroll' do
      it 'redirects to agency payroll outcome' do
        params = {
          looking_for: 'worker',
          worker_type: 'agency_supplied',
          payroll_provider: 'agency'
        }
        get :answer, params: params.merge(slug: 'payroll-provider')
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
        get :answer, params: params.merge(slug: 'payroll-provider')
      end

      it 'redirects to payroll-provider question' do
        expect(response).to redirect_to(
          search_question_path(params.merge(slug: 'payroll-provider'))
        )
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET #question for agency-payroll' do
    it 'sets the back link to the payroll-provider question' do
      params = {
        looking_for: 'worker',
        worker_type: 'agency_supplied',
        payroll_provider: 'agency'
      }
      get :question, params: params.merge(slug: 'agency-payroll')
      expect(assigns(:back_path)).to eq(
        search_question_path(params.merge(slug: 'payroll-provider'))
      )
    end
  end
end
