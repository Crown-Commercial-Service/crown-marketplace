module ManagementConsultancy
  class HomeController < ApplicationController
    require_permission :management_consultancy

    def index; end
  end
end
