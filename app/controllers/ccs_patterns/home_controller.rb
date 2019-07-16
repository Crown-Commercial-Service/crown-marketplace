module CcsPatterns
  class HomeController < FrameworkController
    skip_before_action :authenticate_user!
    before_action :set_back_path, except: :index

    def index; end

    def dynamic_accordian; end

    def supplier_results_v1; end

    def supplier_results_v2; end

    def small_checkboxes; end

    def titles_checkboxes; end

    def numbered_pagination; end

    def table_5050; end

    def supplier_detail; end

    def errors_find_apprentices; end

    def errors_find_apprentices2; end

    def errors_find_apprentices3; end

    def errors_find_apprentices4; end

    def cog_sign_in; end

    def cog_sign_in_password_prompt_change; end

    private

    def set_back_path
      @back_path = :back
    end
  end
end
