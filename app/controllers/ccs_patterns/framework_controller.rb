module CcsPatterns
  class FrameworkController < ::ApplicationController
    before_action :authenticate_user!

    prepend_before_action do
      session[:last_visited_framework] = 'ccs_patterns'
    end
  end
end
