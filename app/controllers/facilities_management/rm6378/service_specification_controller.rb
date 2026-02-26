module FacilitiesManagement
  module RM6378
    class ServiceSpecificationController < FacilitiesManagement::FrameworkController
      before_action :authorize_user

      def show
        @specification = @service.rm6378_service_specifications
      end
    end
  end
end
