require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::FrameworksController do
  let(:default_params) { { service: 'facilities_management/admin' } }

  login_super_admin

  describe 'GET index' do
    it 'renders the index page' do
      get :index
      expect(response).to render_template(:index)
    end

    context 'when logged in as a buyer' do
      login_fm_buyer

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/facilities-management/RM6232/admin/not-permitted'
      end
    end

    context 'when logged in as a supplier' do
      login_fm_supplier

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/facilities-management/RM6232/admin/not-permitted'
      end
    end

    context 'when logged in as a normal amdin' do
      login_fm_admin

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/facilities-management/RM6232/admin/not-permitted'
      end
    end
  end

  describe 'GET edit' do
    let(:framework) { create(:facilities_management_framework) }

    it 'renders the edit page' do
      get :edit, params: { id: framework.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST update' do
    let(:framework) { create(:facilities_management_framework) }
    let(:live_at_yyyy) { framework.live_at.year.to_s }
    let(:live_at_mm) { framework.live_at.month.to_s }
    let(:live_at_dd) { framework.live_at.day.to_s }

    before { post :update, params: { id: framework.id, facilities_management_framework: { live_at_dd: live_at_dd, live_at_mm: live_at_mm, live_at_yyyy: live_at_yyyy } } }

    context 'when the data is valid' do
      it 'redirects to facilities_management_admin_frameworks_path' do
        expect(response).to redirect_to facilities_management_admin_frameworks_path
      end
    end

    context 'when the data is invalid' do
      let(:live_at_mm) { '13' }

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end
end
