module FacilitiesManagement
  module Admin
    class HomeController < FacilitiesManagement::Admin::FrameworkController
      before_action :redirect_if_needed
      before_action :authenticate_user!
      before_action :authorize_user

      def index
        @current_login_email = current_user.email.to_s
      end

      def accessibility_statement
        render 'facilities_management/home/accessibility_statement'
      end

      def cookies
        render 'facilities_management/home/cookies'
      end

      private

      def redirect_if_needed
        redirect_to facilities_management_admin_new_user_session_path unless user_signed_in?
      end
    end
  end
end
