module LegalServices
  class HomeController < FrameworkController
    require_permission :none, only: :index

    def index; end
  end
end
