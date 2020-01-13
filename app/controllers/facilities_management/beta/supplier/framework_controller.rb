module FacilitiesManagement
  module Beta
    module Supplier
      class FrameworkController < ::ApplicationController
        before_action :authenticate_user!
        before_action :authorize_user

        prepend_before_action do
          session[:last_visited_framework] = 'facilities_management/beta/supplier'
        end

        protected

        def authorize_user
          authorize! :read, FacilitiesManagement::Supplier
        end
      end
    end
  end
end
