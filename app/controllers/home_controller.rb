class HomeController < ApplicationController
  skip_before_action :require_sign_in, only: %i[gateway]

  def index; end

  def supply_teachers; end

  def facilities_management; end

  def management_consultancy; end

  def gateway; end

  def status
    render layout: false
  end
end
