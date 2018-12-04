module SupplyTeachers
  class FrameworkController < ::ApplicationController
    require_permission :supply_teachers

    prepend_before_action do
      session[:last_visited_framework] = 'supply_teachers'
    end
  end
end
