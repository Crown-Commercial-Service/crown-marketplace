class HomeController < ApplicationController
  def index; end

  def status
    render layout: false
  end
end
