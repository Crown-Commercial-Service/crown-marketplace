module FacilitiesManagement
  module Beta
    class BuyerAccountController < FrameworkController
      before_action :redirect_if_needed
      before_action :authenticate_user!, only: %i[buyer_account].freeze
      before_action :authorize_user, only: %i[buyer_account].freeze

      def buyer_account
        @current_login_email = current_user.email.to_s
      end

      private

      def redirect_if_needed
        redirect_to facilities_management_beta_start_path unless user_signed_in?
      end
    end
  end
end
