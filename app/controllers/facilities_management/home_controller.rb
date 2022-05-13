module FacilitiesManagement
  class HomeController < FacilitiesManagement::FrameworkController
    before_action :authenticate_user!, :authorize_user, :raise_if_unrecognised_live_framework, :redirect_to_buyer_detail, except: %i[framework index]

    def framework
      redirect_to facilities_management_index_path(FacilitiesManagement::Framework.default_framework)
    end

    def index
      raise_if_unrecognised_live_framework
    end
  end
end
