require 'facilities_management/buyer_details'
module FacilitiesManagement
  module Beta
    class BuyerAccountController < FrameworkController

      def buyer_account
        @current_login_email = current_user.email.to_s
        @buyer_detail = FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user)
      end

      def buyer_details
        @current_login_email = current_user.email.to_s
      end
    end
  end
end
