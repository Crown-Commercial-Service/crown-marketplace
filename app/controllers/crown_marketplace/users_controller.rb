class CrownMarketplace::UsersController < Base::UsersController
  private

  def new_service_challenge_path
    crown_marketplace_users_challenge_path(challenge_name: @challenge.new_challenge_name, username: params[:username])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || crown_marketplace_path
  end

  def confirm_user_registration_path
    crown_marketplace_users_confirm_path(email: params[:email])
  end
end
