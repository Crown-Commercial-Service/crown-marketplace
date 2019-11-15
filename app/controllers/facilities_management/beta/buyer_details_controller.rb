module FacilitiesManagement
  module Beta
    class BuyerDetailsController < FrameworkController
      before_action :set_buyer_detail

      def edit; end

      def edit_address; end

      def update
        if @buyer_detail.update(buyer_detail_params)
          redirect_to facilities_management_beta_path
        else
          render :edit
        end
      end

      private

      def buyer_detail_params
        params.require(:facilities_management_buyer_detail)
              .permit(
                :full_name,
                :job_title,
                :telephone_number,
                :organisation_name,
                :organisation_address_line_1,
                :organisation_address_line_2,
                :organisation_address_town,
                :organisation_address_county,
                :organisation_address_postcode,
                :central_government
              )
      end

      def set_buyer_detail
        @buyer_detail = current_user.buyer_detail
      end
    end
  end
end
