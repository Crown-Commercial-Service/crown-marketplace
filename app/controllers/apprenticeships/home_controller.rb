module Apprenticeships
  class HomeController < FrameworkController
    require_permission :none, only: :index

    def index; end

    def requirements
    end
	
  end
end
