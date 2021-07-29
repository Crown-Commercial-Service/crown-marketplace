module FacilitiesManagement
  module RM6232
    class SessionsController < FacilitiesManagement::SessionsController
      protected

      def challenge_path
        cookies[:session] = { value: @result.session, expires: 20.minutes, httponly: true }
        facilities_management_rm6232_users_challenge_path(challenge_name: @result.challenge_name, username: @result.cognito_uuid)
      end

      def after_sign_in_path_for(resource)
        return redirect_for_spreadsheet_upload(session[:return_to]) if session[:return_to] =~ /spreadsheet_import/

        return session[:return_to] unless session[:return_to].nil?

        stored_location_for(resource) || facilities_management_rm6232_path
      end

      def after_sign_out_path_for(_resource)
        facilities_management_rm6232_new_user_session_path
      end

      def new_session_path
        facilities_management_rm6232_new_user_session_path
      end

      def confirm_forgot_password_path(username)
        facilities_management_rm6232_edit_user_password_path(username: username)
      end

      def confirm_email_path(email)
        facilities_management_rm6232_users_confirm_path(email: email)
      end

      def redirect_for_spreadsheet_upload(session_return_path)
        new_facilities_management_rm6232_procurement_spreadsheet_import_path(procurement_id: session_return_path.split('/')[3])
      end
    end
  end
end
