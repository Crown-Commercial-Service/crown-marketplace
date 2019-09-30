require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::ProcurementsController, type: :controller do
  login_fm_buyer

  let(:procurement) { create(:facilities_management_procurement, name: 'New search') }

  describe 'GET index' do
    it 'renders the correct template' do
      get :index

      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    it 'renders the correct template' do
      get :show, params: { id: procurement.id }

      expect(response).to render_template('show')
    end
  end

  describe 'GET new' do
    it 'renders the correct template' do
      get :new

      expect(response).to render_template('new')
    end
  end

  describe 'GET edit' do
    it 'renders the correct template' do
      get :edit, params: { id: procurement.id }

      expect(response).to render_template('edit')
    end
  end

  describe 'POST create' do
    context 'with a valid record' do
      it 'redirects to show path for the new record' do
        post :create, params: { facilities_management_procurement: { name: 'New procurement' } }

        new_procurement = FacilitiesManagement::Procurement.all.order(created_at: :asc).first
        expect(response).to redirect_to facilities_management_beta_procurement_path(new_procurement.id)
      end
    end

    context 'with an invalid record' do
      it 'render the new template' do
        post :create, params: { facilities_management_procurement: { invalid_param: 'invalid' } }

        expect(response).to render_template('new')
      end
    end
  end

  describe 'PATCH update' do
    context 'with a valid update' do
      before do
        patch :update, params: { id: procurement.id, step: 'name', facilities_management_procurement: { name: 'Updated name' } }
      end

      it 'redirects to the show page for the record' do
        expect(response).to redirect_to facilities_management_beta_procurement_path(procurement.id)
      end

      it 'correctly updates the provided params' do
        procurement.reload

        expect(procurement.name).to eq('Updated name')
      end
    end

    context 'with an invalid update' do
      before do
        patch :update, params: { id: procurement.id, step: 'name', facilities_management_procurement: { name: (0...200).map { ('a'..'z').to_a[rand(26)] }.join } }
      end

      it 'render the edit page for the record' do
        expect(response).to render_template('edit')
      end

      it 'does not update the record' do
        procurement.reload

        expect(procurement.name).to eq('New search')
      end
    end
  end
end
