module FacilitiesManagement
  module Beta
    class GatewayController < FrameworkController
      before_action :authenticate_user!, except: :index
      before_action :authorize_user, except: :index

      def index
        redirect_to facilities_management_beta_start_path if user_signed_in?
      end
    end
  end
end
