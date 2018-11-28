module ManagementConsultancy
  class HomeController < ApplicationController
    before_action { require_framework_permission :management_consultancy }

    def index; end
  end
end
