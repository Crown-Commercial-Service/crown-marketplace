module FacilitiesManagement
  module RM3830
    class HomeController < FacilitiesManagement::FrameworkController
      before_action :authenticate_user!, :authorize_user, except: %i[index]

      def index; end
    end
  end
end
