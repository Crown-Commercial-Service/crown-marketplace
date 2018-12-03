module FacilitiesManagement
  class HomeController < ApplicationController
    require_permission :facilities_management

    def index; end
  end
end
