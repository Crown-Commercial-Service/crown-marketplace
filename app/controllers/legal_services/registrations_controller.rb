module LegalServices
  class RegistrationsController < Base::RegistrationsController
    private

    def ls_access
      :ls_access
    end

    def after_sign_up_path_for(resource)
      legal_services_users_confirm_path(email: resource.email)
    end

    def domain_not_on_whitelist_path
      legal_services_domain_not_on_whitelist_path
    end
  end
end
