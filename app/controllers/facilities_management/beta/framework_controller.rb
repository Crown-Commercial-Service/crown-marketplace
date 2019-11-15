module FacilitiesManagement
  module Beta
    class FrameworkController < ::ApplicationController
      before_action :authenticate_user!
      before_action :authorize_user

      prepend_before_action do
        session[:last_visited_framework] = 'facilities_management/beta'
      end

      protected

      def authorize_user
        authorize! :read, FacilitiesManagement
      end
    end
  end
end
