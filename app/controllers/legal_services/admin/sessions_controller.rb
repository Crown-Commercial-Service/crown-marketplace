module LegalServices
  class SessionsController < Base::SessionsController
    protected

    def after_sign_in_path_for(resource)
      stored_location_for(resource) || legal_services_admin_uploads_path
    end

    def after_sign_out_path_for(_resource)
      legal_services_admin_uploads_path
    end
  end
end
