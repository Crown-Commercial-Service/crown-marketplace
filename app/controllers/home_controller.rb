class HomeController < ApplicationController
  skip_before_action :require_login, only: %i[gateway]
  require_framework_permission :none

  def index; end

  def supply_teachers; end

  def facilities_management; end

  def management_consultancy; end

  def gateway
    redirect_to homepage_path if logged_in?
  end

  def status
    render layout: false
  end
end
