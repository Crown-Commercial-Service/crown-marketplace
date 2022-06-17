module FacilitiesManagement
  module RM6232
    class ServiceSpecificationController < FacilitiesManagement::FrameworkController
      before_action :authorize_user

      def show
        @service = Service.find(params[:service_code].gsub('-', '.'))
        @specification = @service.service_specification
      end
    end
  end
end
