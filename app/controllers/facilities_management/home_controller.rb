module FacilitiesManagement
  class HomeController < ApplicationController
    before_action { require_framework_permission :facilities_management }

    def index; end
  end
end
