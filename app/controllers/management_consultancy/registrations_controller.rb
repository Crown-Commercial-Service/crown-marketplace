module ManagementConsultancy
  class RegistrationsController < Base::RegistrationsController
    private

    def mc_access
      :mc_access
    end

    def after_sign_up_path_for(resource)
      management_consultancy_users_confirm_path(email: resource.email)
    end

    def domain_not_on_whitelist_path
      management_consultancy_domain_not_on_whitelist_path
    end
  end
end
