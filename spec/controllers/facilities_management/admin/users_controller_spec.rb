require 'rails_helper'

RSpec.describe FacilitiesManagement::Admin::UsersController do
  let(:user) { build(:user, email: 'test@test.com') }

  controller(described_class) do
    def confirm_user_registration_path
      params[:email] = 'test@test.com'
      super
    end
  end

  describe 'After sign-in' do
    it 'redirects to the /facilities-management/admin page' do
      expect(controller.send(:after_sign_in_path_for, user)).to eq facilities_management_admin_path
    end

    context 'when confirm user' do
      it 'redirects to the /facilities-management/admin/users/confirm_new page' do
        expect(controller.confirm_user_registration_path).to eq facilities_management_admin_users_confirm_path(email: user.email)
      end
    end
  end
end
