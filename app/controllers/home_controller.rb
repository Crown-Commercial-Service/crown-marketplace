class HomeController < ApplicationController
  require_permission :none, only: :status

  def status
    render layout: false
  end
end
