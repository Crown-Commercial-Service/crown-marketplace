require 'rails_helper'

RSpec.describe CrownMarketplace::ManageDataController do
  let(:default_params) { { service: 'crown_marketplace' } }

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
        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end

    context 'when logged in as a supplier' do
      login_fm_supplier

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end

    context 'when logged in as a normal admin' do
      login_fm_admin

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end

    context 'when I log in as a user support admin' do
      login_user_support_admin

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end

    context 'when I log in as a user admin' do
      login_user_admin

      it 'redirects to not permitted' do
        get :index
        expect(response).to redirect_to '/crown-marketplace/not-permitted'
      end
    end
  end

  describe 'GET new' do
    before { get :new }

    it 'renders the new page' do
      expect(response).to render_template(:new)
    end

    it 'sets data_loader' do
      expect(assigns(:data_loader).class).to be(DataLoader)
    end
  end

  describe 'POST create' do
    let(:application) { 'fm' }
    let(:task_name) { 'bank_holidays' }
    let(:data_loader) { { application:, task_name: } }

    before do
      allow(DataLoaderWorker).to receive(:perform_async)
      allow(LegacyDataLoaderWorker).to receive(:perform_async)

      post :create, params: { data_loader: }
    end

    context 'when it is invalid' do
      let(:data_loader) { nil }

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end

      it 'sets data_loader' do
        expect(assigns(:data_loader).class).to be(DataLoader)
      end
    end

    context 'when it is valid' do
      it 'sets data_loader' do
        expect(assigns(:data_loader).class).to be(DataLoader)
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to crown_marketplace_manage_data_path
      end

      it 'does creates a flash message' do
        expect(flash[:task_details]).to eq(data_loader)
      end

      context 'and the application is fm' do
        it 'calls DataLoaderWorker' do
          expect(DataLoaderWorker).to have_received(:perform_async).with('bank_holidays')
        end
      end

      context 'and the application is legacy' do
        let(:application) { 'legacy' }

        it 'calls LegacyDataLoaderWorker' do
          expect(LegacyDataLoaderWorker).to have_received(:perform_async).with('bank_holidays')
        end
      end
    end
  end
end
