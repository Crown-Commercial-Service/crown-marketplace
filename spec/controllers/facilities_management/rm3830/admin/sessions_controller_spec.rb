require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::Admin::SessionsController do
  let(:default_params) { { service: 'facilities_management/admin', framework: 'RM3830' } }
  let(:user) { build(:user) }

  describe 'After sign-up' do
    it 'redirects to the /facilities-management/RM3830/admin page' do
      expect(controller.send(:after_sign_in_path_for, user)).to eq facilities_management_rm3830_admin_path
    end
  end

  describe 'After sign-out' do
    it 'redirects to the /facilities-management/RM3830/admin/start page' do
      expect(controller.send(:after_sign_out_path_for, user)).to eq facilities_management_rm3830_admin_new_user_session_path
    end
  end
end
