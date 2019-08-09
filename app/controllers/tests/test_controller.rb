module Tests
  class TestController  < ActionController::Base
    ## skip_before_action :authenticate_user!
    # skip_before_action :authorize_user
    skip_before_action :verify_authenticity_token, :only => [:index]

    respond_to :html, :json



    def index
      # params.permit!

      render layout: false
    end

    private

    def set_back_path
      @back_path = :back
    end

    # def post_params(*args)
    #   params.require(:post).permit(*args)
    # end

  end
end
