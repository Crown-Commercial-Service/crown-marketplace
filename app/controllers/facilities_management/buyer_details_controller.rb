module FacilitiesManagement
  class BuyerDetailsController < FacilitiesManagement::FrameworkController
    before_action :set_buyer_detail
    before_action :redirect_to_buyer_detail, except: %i[show edit update]
    before_action :set_section, :set_back_path, only: %i[edit update]

    def show; end

    def edit; end

    def update
      @buyer_detail.assign_attributes(buyer_detail_params)

      if @buyer_detail.save(context: @section)
        redirect_to action: :show
      else
        render :edit
      end
    end

    private

    def buyer_detail_params
      params[:facilities_management_buyer_detail].present? ? params.expect(facilities_management_buyer_detail: SECTION_TO_PARAMS[@section]) : {}
    end

    def set_buyer_detail
      @buyer_detail = FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user)
    end

    def set_section
      @section = params[:section].to_sym

      redirect_to action: :show unless SECTION_TO_PARAMS.include?(@section)
    end

    def set_back_path
      @back_path = facilities_management_buyer_detail_path(params[:framework], @buyer_detail)
      @back_text = t('facilities_management.buyer_details.edit.back')
    end

    SECTION_TO_PARAMS = {
      personal_details: %i[full_name job_title telephone_number],
      organisation_details: %i[organisation_name organisation_address_line_1 organisation_address_line_2 organisation_address_town organisation_address_county organisation_address_postcode sector],
      contact_preferences: %i[contact_opt_in]
    }.freeze
  end
end
