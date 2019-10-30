require 'facilities_management/buyer_details'
module FacilitiesManagement
  module Beta
    class BuyerAccountController < FrameworkController
      before_action :redirect_if_needed
      before_action :authenticate_user!, only: %i[buyer_account buyer_details save_buyer_details retrieve_buyer_details].freeze
      before_action :authorize_user, only: %i[buyer_account buyer_details save_buyer_details retrieve_buyer_details].freeze

      def buyer_account
        @current_login_email = current_user.email.to_s
      end

      def buyer_details
        @current_login_email = current_user.email.to_s
        @buyer_id = save_buyer_details(params) if request.method.to_s == 'POST'
        results = retrieve_buyer_details @current_login_email
        @buyer_record = results.first
      end

      private

      def save_buyer_details(details)
        bd = BuyerDetails.new
        id = bd.save_buyer_details(details, current_user.email.to_s)
        id
      end

      def retrieve_buyer_details(email)
        bd = BuyerDetails.new
        results = bd.buyer_details email
        results
      end

      def redirect_if_needed
        redirect_to facilities_management_beta_start_path unless user_signed_in?
      end
    end
  end
end
