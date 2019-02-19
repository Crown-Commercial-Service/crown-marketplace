module Apprenticeships
  class FrameworkController < ::ApplicationController
    require_permission :apprenticeships

    prepend_before_action do
      session[:last_visited_framework] = 'apprenticeships'
    end
  end
end
