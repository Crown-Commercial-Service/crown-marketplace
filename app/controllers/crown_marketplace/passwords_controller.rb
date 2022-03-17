class CrownMarketplace::PasswordsController < Base::PasswordsController
  protected

  def new_password_path
    crown_marketplace_new_user_password_path
  end

  def after_password_reset_path
    crown_marketplace_password_reset_success_path
  end

  def after_request_password_path
    crown_marketplace_edit_user_password_path
  end
end
