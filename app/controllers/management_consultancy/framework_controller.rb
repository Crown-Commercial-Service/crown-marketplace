module ManagementConsultancy
  class FrameworkController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user

    prepend_before_action do
      session[:last_visited_framework] = 'management_consultancy'
    end

    protected

    def authorize_user
      authorize! :read, ManagementConsultancy
    end
  end
end
