module FacilitiesManagement
  class HomeController < FacilitiesManagement::FrameworkController
    before_action :authenticate_user!, except: %i[index not_permitted accessibility_statement cookies]
    before_action :authorize_user, except: %i[index not_permitted accessibility_statement cookies]

    def index; end

    def not_permitted; end

    def accessibility_statement; end

    def cookies; end
  end
end
