require 'aws-sdk'

module Base
  class RegistrationsController < Devise::RegistrationsController
    protect_from_forgery
    before_action :authenticate_user!, except: %i[new create]
    before_action :authorize_user, except: %i[new create]

    def new
      super
    end

    def create
      result = Cognito::SignUpUser.call(sign_up_params, roles)
      resource = result.user

      if result.success?
        set_flash_message! :notice, :signed_up
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        render :new, erorr: result.error
      end
    end

    private

    def roles
      [:buyer, fm_access, st_access, ls_access, mc_access, at_access]
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

    def at_access
      nil
    end

    def after_sign_up_path_for(resource)
      supply_teachers_users_confirm_path(email: resource.email)
    end

    def authorize_user
      authorize! :read, SupplyTeachers
    end
  end
end
