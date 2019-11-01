module Base
  class SessionsController < Devise::SessionsController
    skip_forgery_protection
    before_action :authenticate_user!, except: %i[new create destroy]
    before_action :authorize_user, except: %i[new create destroy]

    def new
      @result = Cognito::SignInUser.new(nil, nil, nil)
      super
    end

    def create
      self.resource ||= User.new
      @result = Cognito::SignInUser.new(params[:user][:email], params[:user][:password], request.cookies.blank?)
      @result.call

      if @result.success?
        @result.challenge? ? redirect_to(challenge_path) : super
      else
        result_unsuccessful_path
      end
    end

    def destroy
      super
    end

    protected

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || home_page_url
    end

    def after_sign_out_path_for(_resource)
      gateway_url
    end

    def authorize_user
      authorize! :read, SupplyTeachers
    end

    def result_unsuccessful_path
      sign_out
      if @result.needs_password_reset
        redirect_to confirm_forgot_password_path(params[:user][:email])
      elsif @result.needs_confirmation
        redirect_to confirm_email_path(params[:user][:email])
      else
        render :new
      end
    end
  end
end
