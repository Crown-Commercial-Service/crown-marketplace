module FacilitiesManagement
  module RM6232
    class HomeController < FacilitiesManagement::FrameworkController
      before_action :authenticate_user!, :authorize_user, :redirect_to_buyer_detail, except: %i[index]

      def index; end
    end
  end
end
