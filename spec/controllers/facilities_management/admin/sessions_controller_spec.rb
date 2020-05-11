require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SessionsController do
  let(:user) { build(:user) }

  controller(described_class) do
    def after_sign_in_path_for(resource)
      super resource
    end

    def after_sign_out_path_for(resource)
      super resource
    end
  end

  describe 'After sign-up' do
    it 'redirects to the /facilities-management/admin page' do
      expect(controller.after_sign_in_path_for(user)).to eq facilities_management_admin_path
    end
  end

  describe 'After sign-out' do
    it 'redirects to the /facilities-management/admin/start page' do
      expect(controller.after_sign_out_path_for(user)).to eq facilities_management_admin_gateway_path
    end
  end
end
