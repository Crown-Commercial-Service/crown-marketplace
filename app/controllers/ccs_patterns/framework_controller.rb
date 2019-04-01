module CcsPatterns
  class FrameworkController < ::ApplicationController
    require_permission :ccs_patterns

    prepend_before_action do
      session[:last_visited_framework] = 'ccs_patterns'
    end
  end
end
