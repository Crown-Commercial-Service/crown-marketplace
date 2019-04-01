module CcsPatterns
  class HomeController < FrameworkController
    require_permission :none, only: %i[index dynamic_accordian supplier_results_v1]
    before_action :set_back_path, except: :index

    def index; end

    def dynamic_accordian; end

    def supplier_results_v1; end

    private

    def set_back_path
      @back_path = :back
    end
  end
end
