module Tests
  class FrameworkController < ::ApplicationController
    before_action :authenticate_user!

    prepend_before_action do
      session[:last_visited_framework] = 'ccs_test'
    end
  end
end
