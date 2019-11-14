module FacilitiesManagement
  module Beta
    class BuyerDetailsController < FrameworkController
      def edit
        @buyer_detail = current_user.buyer_detail
      end

      def update
      end
    end
  end
end
