module FacilitiesManagement
  module RM6378
    class ServiceSpecificationController < FacilitiesManagement::FrameworkController
      before_action :authorize_user

      def show
        @specification = @service.service_specification
      end
    end
  end
end