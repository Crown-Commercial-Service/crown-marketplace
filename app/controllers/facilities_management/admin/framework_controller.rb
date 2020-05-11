module FacilitiesManagement
  module Admin
    class FrameworkController < ::ApplicationController
      before_action :authenticate_user!
      before_action :authorize_user

      protected

      def authorize_user
        authorize! :manage, FacilitiesManagement::Admin
      end
    end
  end
end
