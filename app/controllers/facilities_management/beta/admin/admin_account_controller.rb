module FacilitiesManagement
  module Beta
    module Admin
      class AdminAccountController < FacilitiesManagement::Beta::Admin::FrameworkController
        before_action :redirect_if_needed
        before_action :authenticate_user!
        before_action :authorize_user

        def admin_account
          @current_login_email = current_user.email.to_s
        end

        private

        def redirect_if_needed
          redirect_to facilities_management_beta_admin_start_path unless user_signed_in?
        end
      end
    end
  end
end
