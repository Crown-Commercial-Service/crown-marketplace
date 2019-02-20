module Apprenticeships
  class HomeController < FrameworkController
    require_permission :none, only: :index
    before_action :set_back_path, except: :index

    def index; end

    def search; end

    def search_results; end

    private

    def set_back_path
      @back_path = :back
    end

  end
end
