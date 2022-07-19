module Base::AuthenticationPathsConcern
  extend ActiveSupport::Concern

  protected

  def edit_password_path
    "#{service_path_base}/users/password"
  end

  def password_reset_success_path
    "#{service_path_base}/users/password-reset-success"
  end

  def new_user_password_path
    "#{service_path_base}/users/forgot-password"
  end

  def new_user_session_path
    "#{service_path_base}/sign-in"
  end

  def domain_not_on_safelist_path
    "#{service_path_base}/domain-not-on-safelist"
  end

  def confirm_email_path
    "#{service_path_base}/users/confirm"
  end

  def sign_up_path
    "#{service_path_base}/sign-up"
  end

  def challenge_user_path
    "#{service_path_base}/users/challenge"
  end

  def service_challenge_path
    "#{challenge_user_path}?#{{ challenge_name: @result.challenge_name }.to_query}"
  end

  def new_service_challenge_path
    "#{challenge_user_path}?#{{ challenge_name: @challenge.new_challenge_name }.to_query}"
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || service_path_base
  end

  def resend_confirmation_email_path
    "#{service_path_base}/resend_confirmation_email"
  end
end
