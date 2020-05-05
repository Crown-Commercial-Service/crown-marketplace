module FacilitiesManagement
  class BuyerDetailsController < FacilitiesManagement::FrameworkController
    before_action :set_buyer_detail

    def show
      render :edit
    end

    def edit; end

    def edit_address; end

    def update
      @buyer_detail.assign_attributes(buyer_detail_params)

      if @buyer_detail.save(context: context_from_params)
        redirect_to_return_url if params['facilities_management_buyer_detail']['return_details'].present?

        return if params['facilities_management_buyer_detail']['return_details'].present?

        redirect_to params[:context] ? edit_facilities_management_buyer_detail_path : facilities_management_path
      else
        render params[:context] ? :edit_address : :edit
      end
    end

    private

    def redirect_to_return_url
      redirect_details = Rack::Utils.parse_nested_query(params['facilities_management_buyer_detail']['return_details'])
      redirect_path = redirect_details['url']
      redirect_params = redirect_details['params']

      redirect_to("#{redirect_path}?#{redirect_params.to_query}") && return if redirect_path.present?

      false
    end

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

    def context_from_params
      params[:context].try(:to_sym) || :update
    end
  end
end
