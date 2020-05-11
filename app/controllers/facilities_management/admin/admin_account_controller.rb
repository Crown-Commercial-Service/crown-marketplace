module FacilitiesManagement
  module Admin
    class AdminAccountController < FacilitiesManagement::Admin::FrameworkController
      before_action :redirect_if_needed
      before_action :authenticate_user!
      before_action :authorize_user

      def admin_account
        @current_login_email = current_user.email.to_s
      end

      private

      def redirect_if_needed
        redirect_to facilities_management_admin_gateway_path unless user_signed_in?
      end
    end
  end
end
