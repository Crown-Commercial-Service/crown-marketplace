module Base
  class UsersController < ApplicationController
    include Base::AuthenticationPathsConcern

    before_action :authenticate_user!, except: %i[confirm_new confirm resend_confirmation_email challenge_new challenge]
    before_action :authorize_user, except: %i[confirm_new confirm resend_confirmation_email challenge_new challenge]
    before_action :set_user_phone, only: %i[challenge_new challenge]

    helper_method :confirm_email_path, :resend_confirmation_email_path, :challenge_user_path, :new_user_session_path

    def confirm_new
      @result = Cognito::ConfirmSignUp.new(nil, nil)
    end

    def confirm
      @result = Cognito::ConfirmSignUp.call(params[:email], params[:confirmation_code])
      if @result.success?
        cookies.delete :crown_marketplace_confirmation_email

        sign_in_user(@result.user)
      else
        render :confirm_new
      end
    end

    def resend_confirmation_email
      result = Cognito::ResendConfirmationCode.call(params[:email])

      redirect_to confirm_email_path, error: result.error
    end

    def challenge_new
      @challenge = Cognito::RespondToChallenge.new(params[:challenge_name], params[:username], params[:session])
    end

    def challenge
      @challenge = Cognito::RespondToChallenge.new(params[:challenge_name], params[:username], params[:session], new_password: params[:new_password], new_password_confirmation: params[:new_password_confirmation], access_code: params[:access_code])
      @challenge.call
      if @challenge.success?
        @challenge.challenge? ? redirect_to(new_challenge_path) : find_and_sign_in_user
      else
        render :challenge_new
      end
    end

    private

    def new_challenge_path
      cookies[:crown_marketplace_challenge_session] = @challenge.new_session
      cookies[:crown_marketplace_challenge_username] = @challenge.cognito_uuid

      new_service_challenge_path
    end

    def find_and_sign_in_user
      cookies.delete :crown_marketplace_challenge_session
      cookies.delete :crown_marketplace_challenge_username

      user = Cognito::CreateUserFromCognito.call(params[:username]).user
      sign_in_user(user)
    end

    def sign_in_user(user)
      sign_in(user)
      redirect_to after_sign_in_path_for(user)
    end

    def set_user_phone
      user_phone_full = User.find_by(cognito_uuid: cookies[:crown_marketplace_challenge_username]).try(:phone_number) || Cognito::CreateUserFromCognito.call(cookies[:crown_marketplace_challenge_username]).try(:user).try(:phone_number)
      @user_phone = ('*' * 9) + user_phone_full.last(3) if user_phone_full
    end
  end
end
