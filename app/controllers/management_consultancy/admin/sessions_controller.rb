module ManagementConsultancy
  module Admin
    class SessionsController < Base::SessionsController
      protected

      def challenge_path
        management_consultancy_admin_users_challenge_path(challenge_name: @result.challenge_name, session: @result.session, username: @result.cognito_uuid)
      end

      def after_sign_in_path_for(resource)
        stored_location_for(resource) || supply_teachers_admin_uploads_path
      end

      def after_sign_out_path_for(_resource)
        management_consultancy_admin_uploads_path
      end

      def new_session_path
        management_consultancy_admin_new_user_session_path
      end

      def confirm_forgot_password_path(username)
        management_consultancy_admin_edit_user_password_path(username: username)
      end
    end
  end
end
