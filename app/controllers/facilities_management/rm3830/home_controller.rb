module FacilitiesManagement
  module RM3830
    class HomeController < FacilitiesManagement::FrameworkController
      include SharedPagesConcern

      skip_before_action :authenticate_user!, :authorize_user, :redirect_to_buyer_detail

      def index; end
    end
  end
end
