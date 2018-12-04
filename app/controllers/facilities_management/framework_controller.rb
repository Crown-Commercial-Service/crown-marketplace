module FacilitiesManagement
  class FrameworkController < ::ApplicationController
    require_permission :facilities_management

    before_action do
      session[:last_visited_framework] = 'facilities_management'
    end
  end
end
