module Base
  class RegistrationsController < Devise::RegistrationsController
    include Base::AuthenticationPathsConcern

    protect_from_forgery
    before_action :authenticate_user!, except: %i[new create domain_not_on_safelist]
    before_action :authorize_user, except: %i[new create domain_not_on_safelist]

    helper_method :sign_up_path

    def new
      @result = Cognito::SignUpUser.new(nil, nil, nil, roles)
      @result.errors.add(:base, flash[:error]) if flash[:error]
      @result.errors.add(:base, flash[:alert]) if flash[:alert]
      super
    end

    def create
      @result = Cognito::SignUpUser.call(sign_up_params[:email], sign_up_params[:password], sign_up_params[:password_confirmation], roles)
      self.resource = @result.user || User.new(sign_up_params)

      if @result.success?
        set_flash_message! :notice, :signed_up
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        fail_create(@result)
      end
    end

    def domain_not_on_safelist; end

    private

    def roles
      [:buyer, fm_access, st_access, ls_access, mc_access]
    end

    def fm_access
      nil
    end

    def st_access
      nil
    end

    def mc_access
      nil
    end

    def ls_access
      nil
    end

    def fail_create(result)
      if result.not_on_safelist
        redirect_to domain_not_on_safelist_path
      else
        clean_up_passwords resource
        set_minimum_password_length
        render :new, erorr: result.error
      end
    end

    def after_sign_up_path_for(resource)
      cookies[:crown_marketplace_confirmation_email] = { value: resource.email, expires: 20.minutes, httponly: true }

      confirm_email_path
    end
  end
end
