module LegalServices
  class HomeController < FrameworkController
    before_action :authenticate_user!, except: :index
    before_action :authorize_user, except: :index

    def index; end

    def service_not_suitable
      @back_path = :back
    end
  end
end
