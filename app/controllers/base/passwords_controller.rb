module Base
  class PasswordsController < ApplicationController
    include Base::AuthenticationPathsConcern

    before_action :authenticate_user!, except: %i[new create edit update password_reset_success]
    before_action :authorize_user, except: %i[new create edit update password_reset_success]

    helper_method :edit_password_path, :new_user_session_path

    def new
      @response = Cognito::ForgotPassword.new(params[:email])
    end

    def edit
      @response = Cognito::ConfirmPasswordReset.new(cookies[:crown_marketplace_reset_email], params[:password], params[:password_confirmation], params[:confirmation_code])
    end

    def create
      @response = Cognito::ForgotPassword.call(create_params[:email])

      if @response.success?
        cookies[:crown_marketplace_reset_email] = { value: create_params[:email], expires: 20.minutes, httponly: true }

        redirect_to edit_password_path
      else
        render :new
      end
    end

    def update
      @response = Cognito::ConfirmPasswordReset.call(update_params[:email], update_params[:password], update_params[:password_confirmation], update_params[:confirmation_code])

      if @response.success?
        cookies.delete :crown_marketplace_reset_email

        redirect_to password_reset_success_path
      else
        render :edit
      end
    end

    def password_reset_success; end

    def create_params
      params.expect(cognito_forgot_password: [:email])
    end

    def update_params
      params.expect(
        cognito_confirm_password_reset: %i[
          email
          password
          password_confirmation
          confirmation_code
        ]
      )
    end
  end
end
