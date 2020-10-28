module LegalServices
  module Admin
    class SessionsController < Base::SessionsController
      protected

      def challenge_path
        cookies[:session] = { value: @result.session, expires: 20.minutes, httponly: true }
        legal_services_admin_users_challenge_path(challenge_name: @result.challenge_name, username: @result.cognito_uuid)
      end

      def after_sign_in_path_for(resource)
        stored_location_for(resource) || legal_services_admin_uploads_path
      end

      def after_sign_out_path_for(_resource)
        legal_services_admin_uploads_path
      end

      def new_session_path
        legal_services_admin_new_user_session_path
      end

      def confirm_forgot_password_path(username)
        management_consultancy_admin_edit_user_password_path(username: username)
      end
    end
  end
end
