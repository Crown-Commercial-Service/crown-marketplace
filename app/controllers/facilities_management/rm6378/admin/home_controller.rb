module FacilitiesManagement
  module RM6378
    module Admin
      class HomeController < FacilitiesManagement::Admin::FrameworkController
        include SharedPagesConcern

        before_action :redirect_if_needed, :authenticate_user!, :authorize_user, only: :index

        def index
          @current_login_email = current_user.email.to_s
        end

        private

        def redirect_if_needed
          redirect_to facilities_management_rm6378_admin_new_user_session_path unless user_signed_in?
        end
      end
    end
  end
end
