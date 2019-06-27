module Base
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: %i[confirm_new confirm challenge_new challenge]
    before_action :authorize_user, except: %i[confirm_new confirm challenge_new challenge]

    def confirm_new; end

    def confirm
      result = Cognito::ConfirmSignUp.call(params[:email], params[:confirmation_code], st_access: true)
      if result.success?
        sign_in_user(result.user)
      else
        render :confirm_new, erorr: result.error
      end
    end

    def challenge_new
      @challenge = Cognito::RespondToChallenge.new(params[:challenge_name], params[:username], params[:session])
    end

    def challenge
      @challenge = Cognito::RespondToChallenge.new(params[:challenge_name], params[:username], params[:session], new_password: params[:new_password], new_password_confirmation: params[:new_password_confirmation], access_code: params[:access_code], st_access: true)
      @challenge.call
      if @challenge.success?
        @challenge.challenge? ? redirect_to(new_challenge_path) : find_and_sign_in_user
      else
        render :challenge_new
      end
    end

    private

    def new_challenge_path
      users_challenge_path(challenge_name: @challenge.new_challenge_name, session: @challenge.new_session, username: @challenge.cognito_uuid)
    end

    def fail_challenge_path
      users_challenge_path(challenge_name: params[:challenge_name], session: params[:session], username: params[:username], errors: @challenge.error)
    end

    def find_and_sign_in_user
      user = User.find_by(cognito_uuid: params[:username]) || Cognito::CreateUserFromCognito.call(params[:username]).user
      sign_in_user(user)
    end

    def sign_in_user(user)
      sign_in(user)
      redirect_to after_sign_in_path_for(user)
    end
  end
end
