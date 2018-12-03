module ManagementConsultancy
  class HomeController < ApplicationController
    require_framework_permission :management_consultancy

    def index; end
  end
end
