module FacilitiesManagement
  module RM3830
    class SessionsController < FacilitiesManagement::SessionsController
      protected

      def service_challenge_path
        facilities_management_rm3830_users_challenge_path(challenge_name: @result.challenge_name)
      end

      def after_sign_in_path_for(resource)
        return redirect_for_spreadsheet_upload(session[:return_to]) if session[:return_to] =~ /spreadsheet_import/

        return session[:return_to] unless session[:return_to].nil?

        stored_location_for(resource) || facilities_management_rm3830_path
      end

      def after_sign_out_path_for(_resource)
        facilities_management_rm3830_new_user_session_path
      end

      def new_session_path
        facilities_management_rm3830_new_user_session_path
      end

      def confirm_forgot_password_path
        facilities_management_rm3830_edit_user_password_path
      end

      def confirm_email_path
        facilities_management_rm3830_users_confirm_path
      end

      def redirect_for_spreadsheet_upload(session_return_path)
        new_facilities_management_rm3830_procurement_spreadsheet_import_path(procurement_id: session_return_path.split('/')[3])
      end
    end
  end
end
