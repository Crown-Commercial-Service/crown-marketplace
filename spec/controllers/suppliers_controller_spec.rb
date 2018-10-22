require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
  describe 'GET master_vendor_managed_service_providers' do
    it 'renders the master_vendor_managed_service_providers template' do
      ensure_logged_in
      get :master_vendor_managed_service_providers
      expect(response).to render_template('master_vendor_managed_service_providers')
    end
  end
end
