class HomeController < ApplicationController
  def index; end

  def supply_teachers; end

  def facilities_management; end

  def management_consultancy; end

  def status
    render layout: false
  end
end
