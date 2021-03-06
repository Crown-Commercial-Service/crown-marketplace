class CrownMarketplace::SessionsController < Base::SessionsController
  protected

  def challenge_path
    cookies[:session] = { value: @result.session, expires: 20.minutes, httponly: true }
    crown_marketplace_users_challenge_path(challenge_name: @result.challenge_name, username: @result.cognito_uuid)
  end

  def after_sign_in_path_for(resource)
    return session[:return_to] unless session[:return_to].nil?

    stored_location_for(resource) ||  crown_marketplace_path
  end

  def after_sign_out_path_for(_resource)
    crown_marketplace_path
  end

  def new_session_path
    crown_marketplace_new_user_session_path
  end

  def confirm_forgot_password_path(username)
    crown_marketplace_edit_user_password_path(username: username)
  end

  def confirm_email_path(email)
    crown_marketplace_users_confirm_path(email: email)
  end
end
