module Base
  class SessionsController < Devise::SessionsController
    skip_forgery_protection
    before_action :authenticate_user!, except: %i[new create destroy]
    before_action :authorize_user, except: %i[new create destroy]

    def new
      @result = Cognito::SignInUser.new(nil, nil)
      @result.errors.add(:base, flash[:error]) if flash[:error]
      super
    end

    def create
      self.resource = User.new
      @result = Cognito::SignInUser.new(params[:user][:email], params[:user][:password])
      @result.call
      if @result.success?
        @result.challenge? ? redirect_to(challenge_path) : super
      else
        flash[:error] = @result.error
        redirect_to new_session_path
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
  end
end
