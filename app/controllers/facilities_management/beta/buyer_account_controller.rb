module FacilitiesManagement
  module Beta
    class BuyerAccountController < FrameworkController
      before_action :redirect_if_needed

      def buyer_account
        @current_login_email = current_user.email.to_s
        @buyer_detail = FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user)
      end

      private

      def redirect_if_needed
        redirect_to facilities_management_beta_start_path unless user_signed_in?
      end
    end
  end
end
