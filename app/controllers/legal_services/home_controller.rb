module LegalServices
  class HomeController < FrameworkController
    require_permission :none, only: :index

    def index; end

    def service_not_suitable
      @back_path = :back
    end
  end
end
