module FacilitiesManagement
  class FrameworkController < ::ApplicationController
    before_action :raise_if_unrecognised_live_framework
    before_action :authenticate_user!
    before_action :authorize_user
    before_action :redirect_to_buyer_detail

    protected

    def authorize_user
      authorize! :read, FacilitiesManagement
    end

    def buyer_path
      edit_facilities_management_buyer_detail_path(params[:framework], FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user))
    end

    def redirect_to_buyer_detail
      redirect_to(buyer_path) if current_user&.fm_buyer_details_incomplete?
    end
  end
end
