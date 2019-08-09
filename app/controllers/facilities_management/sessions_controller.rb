module FacilitiesManagement
  class SessionsController < Base::SessionsController
    protected

    def challenge_path
      facilities_management_users_challenge_path(challenge_name: @result.challenge_name, session: @result.session, username: @result.cognito_uuid)
    end

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || facilities_management_path
    end

    def after_sign_out_path_for(_resource)
      facilities_management_path
    end

    def new_session_path
      facilities_management_new_user_session_path
    end

    def confirm_forgot_password_path(username)
      facilities_management_edit_user_password_path(username: username)
    end

    def confirm_email_path(email)
      facilities_management_users_confirm_path(email: email)
    end
  end
end
