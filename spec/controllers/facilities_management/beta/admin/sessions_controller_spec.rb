require 'rails_helper'

RSpec.describe FacilitiesManagement::Beta::Admin::SessionsController do
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
    it 'redirects to the /facilities-management/beta/admin page' do
      expect(controller.after_sign_in_path_for(user)).to eq facilities_management_beta_admin_path
    end
  end

  describe 'After sign-out' do
    it 'redirects to the /facilities-management/beta/admin/start page' do
      expect(controller.after_sign_out_path_for(user)).to eq facilities_management_beta_admin_start_path
    end
  end
end
