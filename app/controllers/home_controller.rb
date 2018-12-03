class HomeController < ApplicationController
  require_permission :none, only: :gateway
  require_permission :login, except: :gateway

  def index; end

  def gateway
    redirect_to homepage_path if logged_in?
  end

  def status
    render layout: false
  end
end
