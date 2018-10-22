class HomeController < ApplicationController
  skip_before_action :require_login, only: %i[status gateway]

  def index; end

  def gateway; end

  def status
    render layout: false
  end
end
