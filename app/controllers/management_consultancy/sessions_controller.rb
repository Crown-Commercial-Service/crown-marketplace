module ManagementConsultancy
  class SessionsController < Base::SessionsController
    protected

    def challenge_path
      cookies[:session] = { value: @result.session, expires: 20.minutes, httponly: true }
      management_consultancy_users_challenge_path(challenge_name: @result.challenge_name, username: @result.cognito_uuid)
    end

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || management_consultancy_journey_start_path
    end

    def after_sign_out_path_for(_resource)
      management_consultancy_path
    end

    def new_session_path
      management_consultancy_new_user_session_path
    end

    def confirm_forgot_password_path(username)
      management_consultancy_edit_user_password_path(username: username)
    end

    def confirm_email_path(email)
      management_consultancy_users_confirm_path(email: email)
    end
  end
end
