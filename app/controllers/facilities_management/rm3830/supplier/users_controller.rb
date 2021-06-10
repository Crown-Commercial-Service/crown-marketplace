class FacilitiesManagement::RM3830::Supplier::UsersController < Base::UsersController
  private

  def new_challenge_path
    cookies[:session] = @challenge.new_session
    facilities_management_rm3830_supplier_users_challenge_path(challenge_name: @challenge.new_challenge_name, username: params[:username])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || facilities_management_rm3830_supplier_path
  end

  def confirm_user_registration_path
    facilities_management_rm3830_supplier_users_confirm_path(email: params[:email])
  end
end
