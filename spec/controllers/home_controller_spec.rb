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
    render_views

    before { get :not_permitted, params: { service: service } }

    context 'when the service is facilities_management' do
      let(:service) { 'facilities_management' }

      it 'renders the not permitted page' do
        expect(response).to render_template(:not_permitted)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'facilities_management/_header-banner')
      end
    end

    context 'when the service is supply_teachers' do
      let(:service) { 'supply_teachers' }

      it 'renders the not permitted page' do
        expect(response).to render_template(:not_permitted)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'legacy/_header-banner')
      end
    end

    context 'when the service is auth' do
      let(:service) { 'auth' }

      it 'renders the not permitted page' do
        expect(response).to render_template(:not_permitted)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'auth/_header-banner')
      end
    end

    context 'when the service is management_consultancy' do
      let(:service) { 'management_consultancy' }

      it 'renders the not permitted page' do
        expect(response).to render_template(:not_permitted)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'legacy/_header-banner')
      end
    end

    context 'when the service is legal_services' do
      let(:service) { 'legal_services' }

      it 'renders the not permitted page' do
        expect(response).to render_template(:not_permitted)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'legacy/_header-banner')
      end
    end
  end
end
