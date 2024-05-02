require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::ServiceRatesController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }

  login_fm_admin

  describe 'GET show' do
    render_views

    before { get :show, params: { slug: rate_type } }

    context 'when viewing the average framework rates page' do
      let(:rate_type) { 'average-framework-rates' }

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'renders the average-framework-rates partial' do
        expect(response).to render_template(partial: '_average-framework-rates')
      end
    end

    context 'when viewing the call-off benchmark rates page' do
      let(:rate_type) { 'call-off-benchmark-rates' }

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end

      it 'renders the call-off-benchmark-rates partial' do
        expect(response).to render_template(partial: '_call-off-benchmark-rates')
      end
    end
  end
end
