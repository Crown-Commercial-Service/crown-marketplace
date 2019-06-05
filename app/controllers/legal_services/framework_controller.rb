module LegalServices
  class FrameworkController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user

    prepend_before_action do
      session[:last_visited_framework] = 'legal_services'
    end

    protected

    def authorize_user
      authorize! :read, LegalServices
    end
  end
end
