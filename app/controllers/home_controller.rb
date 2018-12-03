class HomeController < ApplicationController
  require_permission :none, only: %i[gateway status]
  require_permission :login, except: %i[gateway status]

  def index; end

  def gateway
    redirect_to homepage_path if logged_in?
  end

  def status
    render layout: false
  end
end
