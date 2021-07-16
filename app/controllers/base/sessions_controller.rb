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
        redirect_to default_sign_in_path
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

      case split_url[1]
      when 'crown-marketplace'
        crown_marketplace_new_user_session_path(expired: true)
      when 'facilities-management'
        framework = if FacilitiesManagement::RECOGNISED_FRAMEWORKS.include?(split_url[2])
                      split_url[2]
                    else
                      FacilitiesManagement::DEFAULT_FRAMEWORK
                    end
        service_type ||= split_url[3] if split_url[3] == 'supplier' || split_url[3] == 'admin'

        "/#{[split_url[1], framework, service_type, 'sign-in'].compact.join('/')}?expired=true"
      else
        default_sign_in_path
      end
    end

    def default_sign_in_path
      facilities_management_rm3830_new_user_session_path(expired: true)
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
