module ManagementConsultancy
  class HomeController < FrameworkController
    require_permission :management_consultancy

    def index; end
  end
end
