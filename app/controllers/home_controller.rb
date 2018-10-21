class HomeController < ApplicationController
  before_action :require_login, except: %i[status gateway]

  def index; end

  def gateway; end

  def status
    render layout: false
  end
end
