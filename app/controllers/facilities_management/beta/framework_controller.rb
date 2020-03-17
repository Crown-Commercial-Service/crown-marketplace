module FacilitiesManagement
  module Beta
    class FrameworkController < ::ApplicationController
      before_action :authenticate_user!
      before_action :authorize_user
      before_action :capture_buyer_detail

      protected

      def authorize_user
        authorize! :read, FacilitiesManagement
      end

      def capture_buyer_detail
        if guarded_path? && current_user&.fm_buyer_details_incomplete? &&
           request.fullpath != edit_facilities_management_beta_buyer_detail_path(FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user))
          redirect_to(edit_facilities_management_beta_buyer_detail_path(FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user)))
        end
      end

      private

      def guarded_path?
        full_path = request.fullpath

        %w[building procurement choose-].any? { |sp| full_path.include?(sp) }
      end
    end
  end
end
