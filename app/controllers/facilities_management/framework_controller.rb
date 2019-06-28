module FacilitiesManagement
  class FrameworkController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user

    before_action do
      session[:last_visited_framework] = 'facilities_management'
    end

    protected

    def authorize_user
      authorize! :read, FacilitiesManagement
    end
  end
end
