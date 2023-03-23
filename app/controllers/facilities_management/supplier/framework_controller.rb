module FacilitiesManagement
  module Supplier
    class FrameworkController < ApplicationController
      include FrameworkStatusConcern

      before_action :authenticate_user!
      before_action :authorize_user

      protected

      def authorize_user
        authorize! :read, FacilitiesManagement::RM3830::SupplierDetail
      end
    end
  end
end
