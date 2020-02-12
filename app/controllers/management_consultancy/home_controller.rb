module ManagementConsultancy
  class HomeController < ManagementConsultancy::FrameworkController
    before_action :authenticate_user!, except: :index
    before_action :authorize_user, except: :index

    def index; end
  end
end
