require 'rails_helper'

RSpec.describe CrownMarketplace::HomeController, type: :controller do
  let(:default_params) { { service: 'crown_marketplace' } }

  describe 'GET accessibility_statement' do
    it 'renders the accessibility_statement page' do
      get :accessibility_statement

      expect(response).to render_template('home/accessibility_statement')
    end
  end

  describe 'GET cookie_policy' do
    it 'renders the cookie policy page' do
      get :cookie_policy

      expect(response).to render_template('home/cookie_policy')
    end
  end

  describe 'GET cookie_settings' do
    it 'renders the cookie settings page' do
      get :cookie_settings

      expect(response).to render_template('home/cookie_settings')
    end
  end

  describe 'PUT update_cookie_settings' do
    context 'when enableing the cookies' do
      before do
        %i[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
          cookies[cookie_name] = { value: 'test_cookie', domain: '.crowncommercial.gov.uk', path: '/' }
        end

        put :update_cookie_settings, params: { ga_cookie_usage: 'true' }
      end

      it 'sets the cookie' do
        expect(cookies[:crown_marketplace_google_analytics_enabled]).to eq('true')

        %i[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
          expect(cookies[cookie_name]).to eq 'test_cookie'
        end
      end

      it 'updates the cookies_updated param' do
        expect(controller.params[:cookies_updated]).to be true
      end

      it 'renders the cookie_settings template' do
        expect(response).to render_template('home/cookie_settings')
      end
    end

    context 'when disabling the cookies' do
      before do
        cookies[:crown_marketplace_google_analytics_enabled] = { value: 'true' }

        %i[_ga_cookie _gi_cookie _cls_cookie].each do |cookie_name|
          cookies[cookie_name] = { value: 'test_cookie', domain: '.crowncommercial.gov.uk', path: '/' }
        end

        put :update_cookie_settings, params: { ga_cookie_usage: 'false' }
      end

      it 'deletes the cookie' do
        %w[_ga_cookie _gi_cookie _cls_cookie crown_marketplace_google_analytics_enabled].each do |cookie_name|
          expect(response.cookies[cookie_name]).to be_nil
        end
      end

      it 'updates the cookies_updated param' do
        expect(controller.params[:cookies_updated]).to be true
      end

      it 'renders the cookie_settings template' do
        expect(response).to render_template('home/cookie_settings')
      end
    end
  end

  describe 'GET not_permitted' do
    it 'renders the not_permitted page' do
      get :not_permitted

      expect(response).to render_template('home/not_permitted')
    end
  end
end
