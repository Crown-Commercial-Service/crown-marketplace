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
    context 'with a procurement in the quick search state' do
      it 'redirects to the edit path' do
        get :show, params: { id: procurement.id }

        expect(response).to redirect_to edit_facilities_management_beta_procurement_path(procurement.id)
      end
    end

    context 'with a procurement in the detailed search state' do
      before { procurement.update(aasm_state: 'detailed_search') }

      it 'renders the show template' do
        get :show, params: { id: procurement.id }

        expect(response).to render_template('show')
      end
    end
  end

  describe 'GET new' do
    it 'renders the correct template' do
      get :new, params: { region_codes: ['UKC1'], service_codes: ['C.1'] }

      expect(response).to render_template('new')
    end
  end

  describe 'GET edit' do
    it 'renders the correct template' do
      get :edit, params: { id: procurement.id, step: 'tupe' }

      expect(response).to render_template('edit')
    end
  end

  describe 'POST create' do
    context 'with a valid record' do
      it 'redirects to edit path for the new record' do
        post :create, params: { facilities_management_procurement: { name: 'New procurement' } }

        new_procurement = FacilitiesManagement::Procurement.all.order(created_at: :asc).first
        expect(response).to redirect_to edit_facilities_management_beta_procurement_path(new_procurement.id)
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
        procurement.update(aasm_state: 'detailed_search')
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
        patch :update, params: { id: procurement.id, facilities_management_procurement: { name: (0...200).map { ('a'..'z').to_a[rand(26)] }.join, step: 'name' } }
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

  describe '#sent_offer?' do
    context 'when supplied quick_search or detailed_search' do
      it 'will return true' do
        expect(controller.send(:search?, :quick_search)).to be true
        expect(controller.send(:search?, :detailed_search)).to be true
      end
    end

    context 'when further_competition or results' do
      it 'will return true' do
        expect(controller.send(:search?, :further_competition)).to be true
        expect(controller.send(:search?, :results)).to be true
      end
    end
  end

  describe '#sent_offer?' do
    context 'when supplied quick_search or detailed_search' do
      it 'will return false' do
        expect(controller.send(:sent_offer?, :quick_search)).to be false
        expect(controller.send(:sent_offer?, :detailed_search)).to be false
      end
    end

    context 'when supplied DA_draft, further_competition or results' do
      it 'will return false' do
        expect(controller.send(:sent_offer?, :DA_draft)).to be false
        expect(controller.send(:sent_offer?, :further_competition)).to be false
        expect(controller.send(:sent_offer?, :results)).to be false
      end
    end

    context 'when supplied awaiting_supplier_response or awaiting_contract_signature' do
      it 'will return true' do
        expect(controller.send(:sent_offer?, :awaiting_supplier_response)).to be true
        expect(controller.send(:sent_offer?, :awaiting_contract_signature)).to be true
      end
    end

    context 'when supplied supplier_declined, no_supplier_response or accepted_not_signed' do
      it 'will return true' do
        expect(controller.send(:sent_offer?, :supplier_declined)).to be true
        expect(controller.send(:sent_offer?, :no_supplier_response)).to be true
        expect(controller.send(:sent_offer?, :accepted_not_signed)).to be true
      end
    end
  end
end
