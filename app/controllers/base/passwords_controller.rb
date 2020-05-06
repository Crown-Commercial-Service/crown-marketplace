module Base
  class PasswordsController < ApplicationController
    before_action :authenticate_user!, except: %i[new create confirm_new edit update password_reset_success]
    before_action :authorize_user, except: %i[new create confirm_new edit update password_reset_success]

    def new
      @response = Cognito::ForgotPassword.new(params[:email])
    end

    def create
      @response = Cognito::ForgotPassword.call(params[:email])
      if @response.success?
        return_path = params.dig('supplier').present? ? after_request_password_path(true) : after_request_password_path
      else
        flash[:error] = @response.error
        return_path = params.dig('supplier').present? ? new_password_path(true) : new_password_path
      end
      redirect_to return_path
    end

    def edit
      @response = Cognito::ConfirmPasswordReset.new(params[:email], params[:password], params[:password_confirmation], params[:confirmation_code])
    end

    def update
      email = params[:user_email_reset_by_CSC].blank? ? params[:user_email_reset_by_themself] : params[:user_email_reset_by_CSC]

      @response = Cognito::ConfirmPasswordReset.call(email, params[:password], params[:password_confirmation], params[:confirmation_code])
      if @response.success?
        return_path = params.dig('supplier').present? ? after_password_reset_path(true) : after_password_reset_path

        redirect_to return_path
      else
        render :edit, erorr: @response.error
      end
    end

    def password_reset_success; end

    def confirm_new; end
  end
end
