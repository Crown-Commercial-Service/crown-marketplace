module Base
  class SessionsController < Devise::SessionsController
    skip_forgery_protection
    before_action :authenticate_user!, except: %i[new create destroy active timeout]
    before_action :authorize_user, except: %i[new create destroy active timeout]
    before_action :validate_service, except: %i[destroy active timeout]

    def new
      @result = Cognito::SignInUser.new(nil, nil, nil)
      super
    end

    def create
      if Rails.env.production?
        self.resource ||= User.new
        @result = Cognito::SignInUser.new(params[:user][:email], params[:user][:password], request.cookies.blank?)
        @result.call

        if @result.success?
          @result.challenge? ? redirect_to(challenge_path) : super
        else
          result_unsuccessful_path
        end
      else
        super
      end
    end

    def destroy
      session.delete(current_user.id)
      current_user.invalidate_session!
      current_user.save!
      super
    end

    def active
      render_session_status
    end

    def timeout
      session[:return_to] = params[:url]

      begin
        redirect_to session_expired_sign_in_path
      rescue ActionController::RoutingError
        redirect_to facilities_management_new_user_session_path(expired: true)
      end
    end

    protected

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || sign_in_url
    end

    def after_sign_out_path_for(_resource)
      sign_in_url
    end

    def session_expired_sign_in_path
      split_url = params[:url].split('/')
      service = split_url[1]
      service_type ||= split_url[2] if split_url[2] == 'supplier' || split_url[2] == 'admin'

      "/#{[service, service_type, 'sign-in'].compact.join('/')}?expired=true"
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
