module FacilitiesManagement
  class RegistrationsController < Base::RegistrationsController

    private

    def fm_access
      :fm_access
    end

    def after_sign_up_path_for(resource)
      facilities_management_users_confirm_path(email: resource.email)
    end
  end
end
