require 'json'
require 'facilities_management/fm_cache_data'
class FacilitiesManagement::BuyerAccountController < FacilitiesManagement::FrameworkController
  before_action :authenticate_user!, only: %i[buyer_account].freeze
  before_action :authorize_user, only: %i[buyer_account].freeze

  def buyer_account
    @current_login_email = current_user.email.to_s
    render 'facilities_management/home/buyer_account_landing_page'
  end
end
