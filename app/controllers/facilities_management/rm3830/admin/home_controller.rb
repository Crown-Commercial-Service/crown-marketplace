module FacilitiesManagement
  module RM3830
    module Admin
      class HomeController < FacilitiesManagement::Admin::FrameworkController
        before_action :redirect_if_needed, only: :index

        def index
          @current_login_email = current_user.email.to_s
        end

        private

        def redirect_if_needed
          redirect_to facilities_management_admin_new_user_session_path unless user_signed_in?
        end
      end
    end
  end
end
