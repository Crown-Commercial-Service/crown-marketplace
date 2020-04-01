module FacilitiesManagement
  module Beta
    class FrameworkController < ::ApplicationController
      before_action :authenticate_user!
      before_action :authorize_user
      before_action :redirect_to_buyer_detail

      protected

      def authorize_user
        authorize! :read, FacilitiesManagement
      end

      def buyer_path
        @buyer_path ||= edit_facilities_management_beta_buyer_detail_path(FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user))
      end

      def redirect_to_buyer_detail
        redirect_to(buyer_path, params: { return_to: { url: request.path, params: request.query_parameters } }) if guarded_path? && current_user&.fm_buyer_details_incomplete? && request.path != buyer_path
      end

      private

      def guarded_path?
        full_path = request.path

        %w[building procurement choose-].any? { |sp| full_path.include?(sp) }
      end
    end
  end
end
