require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET index' do
    it 'redirects to the CCS home page' do
      get :index
      expect(response).to redirect_to('https://www.crowncommercial.gov.uk/')
    end
  end

  describe 'GET status' do
    it 'displays status information about the app' do
      get :status
      expect(response).to render_template(:status, layout: false)
    end
  end

  describe 'GET not-permitted' do
    before { get :not_permitted, params: { service: service } }

    context 'when the service is facilities_management' do
      let(:service) { 'facilities_management' }

      it 'redirects to the facilities_management_not_permitted_path' do
        expect(response).to redirect_to('/facilities-management/not-permitted')
      end
    end

    context 'when the service is supply_teachers' do
      let(:service) { 'supply_teachers' }

      it 'redirects to the supply_teachers_not_permitted_path' do
        expect(response).to redirect_to('/supply-teachers/not-permitted')
      end
    end

    context 'when the service is auth' do
      let(:service) { 'auth' }

      it 'redirects to the supply_teachers_not_permitted_path' do
        expect(response).to redirect_to('/supply-teachers/not-permitted')
      end
    end

    context 'when the service is management_consultancy' do
      let(:service) { 'management_consultancy' }

      it 'redirects to the management_consultancy_not_permitted_path' do
        expect(response).to redirect_to('/management-consultancy/not-permitted')
      end
    end

    context 'when the service is legal_services' do
      let(:service) { 'legal_services' }

      it 'redirects to the legal_services_not_permitted_path' do
        expect(response).to redirect_to('/legal-services/not-permitted')
      end
    end

    context 'when the service is not in the list' do
      let(:service) { 'apprenticeships' }

      it 'redirects to the 404 page not found' do
        expect(response).to redirect_to '/404'
      end
    end
  end
end
