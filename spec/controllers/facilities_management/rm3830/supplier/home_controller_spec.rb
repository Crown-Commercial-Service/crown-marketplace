require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Supplier::HomeController, type: :controller do
  let(:default_params) { { service: 'facilities_management/supplier', framework: 'RM3830' } }

  describe '#index' do
    subject(:index) { get :index }

    context 'when signed in' do
      login_fm_supplier

      it 'redirects to supplier dashboard' do
        expect(index).to redirect_to(facilities_management_rm3830_supplier_dashboard_index_path)
      end
    end

    context 'when not signed in' do
      it 'redirects to supplier sign in' do
        expect(index).to redirect_to(facilities_management_rm3830_supplier_new_user_session_path)
      end
    end
  end

  describe 'validate service' do
    context 'when the service is not a valid service' do
      let(:default_params) { { service: 'apprenticeships' } }

      it 'renders the erros_not_found page' do
        get :index

        expect(response).to redirect_to errors_404_path
      end
    end
  end
end
