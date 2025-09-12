module FacilitiesManagement
  module RM6378
    class BuyerAccountController < FacilitiesManagement::FrameworkController
      before_action :redirect_if_needed
      before_action :authenticate_user!
      before_action :authorize_user

      def index
        @current_login_email = current_user.email.to_s
        @buyer_detail = FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user)
      end

      private

      def redirect_if_needed
        redirect_to facilities_management_rm6378_start_path unless user_signed_in?
      end
    end
  end
end
