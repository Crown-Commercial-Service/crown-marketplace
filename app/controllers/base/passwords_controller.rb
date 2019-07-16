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
        redirect_to after_request_password_path
      else
        flash[:error] = @response.error
        redirect_to new_password_path
      end
    end

    def edit
      @response = Cognito::ConfirmPasswordReset.new(params[:email], params[:password], params[:password_confirmation], params[:confirmation_code])
    end

    def update
      @response = Cognito::ConfirmPasswordReset.call(params[:username], params[:password], params[:password_confirmation], params[:confirmation_code])
      if @response.success?
        redirect_to after_password_reset_path
      else
        render :edit, erorr: @response.error
      end
    end

    def password_reset_success; end

    def confirm_new; end
  end
end
