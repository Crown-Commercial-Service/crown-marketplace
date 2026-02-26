module FacilitiesManagement
  module RM6378
    class ServiceSpecificationController < FacilitiesManagement::FrameworkController
      before_action :authorize_user

      def show
        @service = Service.where("id LIKE 'RM6378%'").find_by(number: params[:service_code])
        @specification = ServiceSpecificationParser.new(@service.category, @service.number) 
      end
    end
  end
end
