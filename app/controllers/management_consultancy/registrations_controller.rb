module ManagementConsultancy
  class RegistrationsController < Base::RegistrationsController

    private

    def mc_access
      :mc_access
    end

    def after_sign_up_path_for(resource)
      management_consultancy_users_confirm_path(email: resource.email)
    end
  end
end
