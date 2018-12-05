class HomeController < ApplicationController
  require_permission :none, only: %i[status index]

  def index
    redirect_to ccs_homepage_url
  end

  def status
    render layout: false
  end
end
