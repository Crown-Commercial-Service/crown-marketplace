module FacilitiesManagement
  class HomeController < FrameworkController
    require_permission :facilities_management

    def index; end
  end
end
