require 'rails_helper'

RSpec.describe FacilitiesManagement::HomeController, type: :controller do
  describe 'GET index' do
    it 'renders the index page' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET not_permitted' do
    it 'renders the not_permitted page' do
      get :not_permitted
      expect(response).to render_template(:not_permitted)
    end
  end

  describe 'GET accessibility_statement' do
    it 'renders the accessibility_statement page' do
      get :accessibility_statement
      expect(response).to render_template(:accessibility_statement)
    end

    context 'when from an admin page' do
      before { get :accessibility_statement, params: { service: 'facilities_management/admin' } }

      render_views

      it 'renders the accessibility_statement page' do
        expect(response).to render_template(:accessibility_statement)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'facilities_management/admin/_header-banner')
      end
    end

    context 'when from an suppliers page' do
      before { get :accessibility_statement, params: { service: 'facilities_management/supplier' } }

      render_views

      it 'renders the accessibility_statement page' do
        expect(response).to render_template(:accessibility_statement)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'facilities_management/supplier/_header-banner')
      end
    end
  end

  describe 'GET cookies' do
    it 'renders the index page' do
      get :cookies
      expect(response).to render_template(:cookies)
    end

    context 'when from an admin page' do
      before { get :cookies, params: { service: 'facilities_management/admin' } }

      render_views

      it 'renders the cookies page' do
        expect(response).to render_template(:cookies)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'facilities_management/admin/_header-banner')
      end
    end

    context 'when from an suppliers page' do
      before { get :cookies, params: { service: 'facilities_management/supplier' } }

      render_views

      it 'renders the cookies page' do
        expect(response).to render_template(:cookies)
      end

      it 'renders the correct header banner' do
        expect(response).to render_template(partial: 'facilities_management/supplier/_header-banner')
      end
    end
  end
end
