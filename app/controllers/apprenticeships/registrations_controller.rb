module Apprenticeships
  class RegistrationsController < Base::RegistrationsController
    private

    def at_access
      :at_access
    end

    def after_sign_up_path_for(resource)
      apprenticeships_users_confirm_path(email: resource.email)
    end
  end
end
