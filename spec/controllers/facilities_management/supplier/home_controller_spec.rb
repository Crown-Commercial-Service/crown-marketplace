require 'rails_helper'

RSpec.describe FacilitiesManagement::Supplier::HomeController do
  let(:default_params) { { service: 'facilities_management' } }

  describe 'GET framework' do
    context 'when RM3830 is live' do
      include_context 'and RM6232 is live in the future'

      it 'redirects to the RM3830 admin home page' do
        get :framework
        expect(response).to redirect_to facilities_management_rm3830_supplier_path
      end
    end

    context 'when RM6232 is live' do
      it 'redirects to the RM3830 admin home page' do
        get :framework
        expect(response).to redirect_to facilities_management_rm3830_supplier_path
      end
    end
  end

  describe 'validate service' do
    context 'when the service is not a valid service' do
      let(:default_params) { { service: 'apprenticeships' } }

      it 'renders the erros_not_found page' do
        get :framework

        expect(response).to redirect_to errors_404_path
      end
    end
  end
end
