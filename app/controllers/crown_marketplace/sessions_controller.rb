class CrownMarketplace::SessionsController < Base::SessionsController
  protected

  def service_challenge_path
    crown_marketplace_users_challenge_path(challenge_name: @result.challenge_name)
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

  def confirm_forgot_password_path
    crown_marketplace_edit_user_password_path
  end

  def confirm_email_path
    crown_marketplace_users_confirm_path
  end
end
