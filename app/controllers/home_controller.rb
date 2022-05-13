class HomeController < ApplicationController
  before_action :authenticate_user!, :validate_service, except: %i[status index]

  def index
    redirect_to ccs_homepage_url
  end

  def status
    render layout: false
  end
end
