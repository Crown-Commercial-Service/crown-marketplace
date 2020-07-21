require 'rails_helper'

RSpec.describe FacilitiesManagement::Supplier::HomeController, type: :controller do
  describe '#index' do
    subject(:index) { get :index }

    context 'when signed in' do
      login_fm_supplier

      it 'redirects to supplier dashboard' do
        expect(index).to redirect_to(facilities_management_supplier_dashboard_index_path)
      end
    end

    context 'when not signed in' do
      it 'redirects to supplier sign in' do
        expect(index).to redirect_to(facilities_management_supplier_new_user_session_path)
      end
    end
  end
end
