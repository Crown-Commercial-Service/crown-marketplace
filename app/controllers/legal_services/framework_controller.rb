module LegalServices
  class FrameworkController < ::ApplicationController
    require_permission :legal_services

    prepend_before_action do
      session[:last_visited_framework] = 'legal_services'
    end
  end
end
