module FacilitiesManagement
  module Beta
    class BuyerAccountController < FrameworkController
      before_action :authenticate_user!, only: %i[buyer_account].freeze
      before_action :authorize_user, only: %i[buyer_account].freeze

      def buyer_account
        @current_login_email = current_user.email.to_s
      end
    end
  end
end
