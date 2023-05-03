module Base
  class SessionsController < Devise::SessionsController
    include Base::AuthenticationPathsConcern

    skip_forgery_protection
    before_action :authenticate_user!, except: %i[new create destroy active timeout]
    before_action :authorize_user, except: %i[new create destroy active timeout]
    before_action :validate_service, except: %i[destroy active timeout]

    helper_method :new_user_session_path, :new_user_password_path, :sign_up_path

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
        redirect_to "#{params[:service_path_base]}/sign-in?expired=true"
      rescue ActionController::RoutingError
        redirect_to "#{service_path_base}/sign-in?expired=true"
      end
    end

    protected

    def after_sign_out_path_for(_resource)
      sign_in_url
    end

    def result_unsuccessful_path
      sign_out
      if @result.needs_password_reset
        cookies[:crown_marketplace_reset_email] = { value: params[:user][:email], expires: 20.minutes, httponly: true }

        redirect_to edit_password_path
      elsif @result.needs_confirmation
        cookies[:crown_marketplace_confirmation_email] = { value: params[:user][:email], expires: 20.minutes, httponly: true }

        redirect_to confirm_email_path
      else
        render :new
      end
    end

    def challenge_path
      cookies[:crown_marketplace_challenge_session] = { value: @result.session, expires: 20.minutes, httponly: true }
      cookies[:crown_marketplace_challenge_username] = { value: @result.cognito_uuid, expires: 20.minutes, httponly: true }

      service_challenge_path
    end
  end
end
