module FacilitiesManagement
  class FrameworkController < ::ApplicationController
    before_action :authenticate_user!
    before_action :authorize_user
    before_action :redirect_to_buyer_detail
    before_action :raise_if_unrecognised_framework

    protected

    def authorize_user
      authorize! :read, FacilitiesManagement
    end

    def buyer_path
      edit_facilities_management_buyer_detail_path(params[:framework], FacilitiesManagement::BuyerDetail.find_or_create_by(user: current_user))
    end

    def redirect_to_buyer_detail
      redirect_to(buyer_path) if !path_an_exception? && current_user&.fm_buyer_details_incomplete?
    end

    private

    def path_an_exception?
      full_path = request.path

      %w[users sign-in sign-out resend_confirmation_email sign-up domain-not-on-safelist buyer-details api not-permitted cookies accessibility-statement].any? { |path_section| full_path.include?(path_section) }
    end
  end
end
