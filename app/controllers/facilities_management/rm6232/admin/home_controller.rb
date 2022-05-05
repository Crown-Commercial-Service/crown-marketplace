module FacilitiesManagement
  module RM6232
    module Admin
      class HomeController < FacilitiesManagement::Admin::FrameworkController
        before_action :redirect_if_needed, :authenticate_user!, :authorize_user

        def index
          @current_login_email = current_user.email.to_s
        end

        private

        def redirect_if_needed
          redirect_to facilities_management_rm6232_admin_new_user_session_path unless user_signed_in?
        end
      end
    end
  end
end
