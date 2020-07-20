module Apprenticeships
  class PasswordsController < Base::PasswordsController
    protected

    def new_password_path
      apprenticeships_new_user_password_path
    end

    def edit_password_path
      apprenticeships_edit_user_password_path
    end

    def after_password_reset_path
      apprenticeships_password_reset_success_path
    end

    def after_request_password_path
      apprenticeships_edit_user_password_path(email: params[:email])
    end
  end
end
