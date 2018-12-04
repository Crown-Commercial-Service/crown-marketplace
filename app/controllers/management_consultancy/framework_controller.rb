module ManagementConsultancy
  class FrameworkController < ::ApplicationController
    require_permission :management_consultancy

    prepend_before_action do
      session[:last_visited_framework] = 'management_consultancy'
    end
  end
end
