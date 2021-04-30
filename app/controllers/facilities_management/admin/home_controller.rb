module FacilitiesManagement
  module Admin
    class HomeController < FacilitiesManagement::Admin::FrameworkController
      before_action :redirect_if_needed, only: :index
      before_action :authenticate_user!, :authorize_user, except: %i[accessibility_statement cookie_policy cookie_settings]

      def index
        @current_login_email = current_user.email.to_s
      end

      def accessibility_statement
        render 'home/accessibility_statement'
      end

      def cookie_policy
        render 'home/cookie_policy'
      end

      def cookie_settings
        render 'home/cookie_settings'
      end

      private

      def redirect_if_needed
        redirect_to facilities_management_admin_new_user_session_path unless user_signed_in?
      end
    end
  end
end
