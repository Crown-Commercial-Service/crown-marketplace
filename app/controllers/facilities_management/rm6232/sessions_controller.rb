module FacilitiesManagement
  module RM6232
    class SessionsController < FacilitiesManagement::SessionsController
      protected

      def service_challenge_path
        facilities_management_rm6232_users_challenge_path(challenge_name: @result.challenge_name)
      end

      def after_sign_in_path_for(resource)
        return session[:return_to] unless session[:return_to].nil?

        stored_location_for(resource) || facilities_management_rm6232_path
      end

      def after_sign_out_path_for(_resource)
        facilities_management_rm6232_new_user_session_path
      end

      def new_session_path
        facilities_management_rm6232_new_user_session_path
      end

      def confirm_forgot_password_path
        facilities_management_rm6232_edit_user_password_path
      end

      def confirm_email_path
        facilities_management_rm6232_users_confirm_path
      end
    end
  end
end
