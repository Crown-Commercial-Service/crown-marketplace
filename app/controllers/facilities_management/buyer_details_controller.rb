module FacilitiesManagement
  class BuyerDetailsController < FacilitiesManagement::FrameworkController
    before_action :set_buyer_detail
    before_action :redirect_to_buyer_detail, except: %i[edit edit_address update]

    def edit; end

    def edit_address; end

    def update
      assign_params

      context = context_from_params

      if @buyer_detail.save(context:)
        redirect_to redirect_path(context)
      else
        render render_template(context)
      end
    end

    private

    def assign_params
      @buyer_detail.assign_attributes(buyer_detail_params)
    end

    def redirect_path(context)
      case context
      when :update
        facilities_management_index_path
      when :update_address
        edit_facilities_management_buyer_detail_path
      end
    end

    def render_template(context)
      case context
      when :update
        :edit
      when :update_address
        :edit_address
      end
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
      @buyer_detail = FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user)
    end

    def context_from_params
      params[:context].try(:to_sym) || :update
    end
  end
end
