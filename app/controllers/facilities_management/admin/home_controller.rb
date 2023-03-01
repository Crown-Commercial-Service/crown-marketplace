module FacilitiesManagement
  module Admin
    class HomeController < FacilitiesManagement::Admin::FrameworkController
      before_action :authenticate_user!, :authorize_user, :raise_if_unrecognised_framework, except: %i[framework index]

      def framework
        redirect_to facilities_management_admin_index_path(Framework.facilities_management.current_framework)
      end

      def index
        raise_if_unrecognised_framework
      end
    end
  end
end
