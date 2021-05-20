require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::SessionsController do
  let(:default_params) { { service: 'facilities_management/admin' } }
  let(:user) { build(:user) }

  describe 'After sign-up' do
    it 'redirects to the /facilities-management/admin page' do
      expect(controller.send(:after_sign_in_path_for, user)).to eq facilities_management_admin_path
    end
  end

  describe 'After sign-out' do
    it 'redirects to the /facilities-management/admin/start page' do
      expect(controller.send(:after_sign_out_path_for, user)).to eq facilities_management_admin_new_user_session_path
    end
  end
end
