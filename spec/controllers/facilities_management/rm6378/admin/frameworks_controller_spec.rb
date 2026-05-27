require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Admin::FrameworksController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM6378' } }
  let(:framework) { Framework.find('RM6378') }

  login_super_admin

  describe 'GET show' do
    it 'renders the show page' do
      get :show

      expect(response).to render_template(:show)
    end

    it 'sets the framework' do
      get :show

      expect(assigns(:framework).id).to eq(framework.id)
    end

    context 'when logged in as a buyer' do
      login_fm_buyer

      it 'redirects to not permitted' do
        get :show

        expect(response).to redirect_to '/facilities-management/RM6378/admin/not-permitted'
      end
    end

    context 'when logged in as a normal admin' do
      login_fm_admin

      it 'redirects to not permitted' do
        get :show

        expect(response).to redirect_to '/facilities-management/RM6378/admin/not-permitted'
      end
    end
  end

  describe 'GET edit' do
    before { get :edit }

    it 'renders the edit page' do
      expect(response).to render_template(:edit)
    end

    it 'sets the framework' do
      expect(assigns(:framework).id).to eq(framework.id)
    end
  end

  describe 'POST update' do
    let(:live_at_yyyy) { framework.live_at.year.to_s }
    let(:live_at_mm) { framework.live_at.month.to_s }
    let(:live_at_dd) { framework.live_at.day.to_s }

    before { post :update, params: { framework_update: { live_at_dd:, live_at_mm:, live_at_yyyy: } } }

    it 'sets the framework' do
      expect(assigns(:framework).id).to eq(framework.id)
    end

    context 'when the data is valid' do
      it 'redirects to facilities_management_rm6378_admin_frameworks_path' do
        expect(response).to redirect_to facilities_management_rm6378_admin_frameworks_path
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
