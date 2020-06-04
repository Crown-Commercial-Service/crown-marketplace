module FacilitiesManagement
  class GatewayController < FacilitiesManagement::FrameworkController
    before_action :authenticate_user!, except: :index
    before_action :authorize_user, except: :index

    # rubocop:disable Style/AndOr
    def validate
      render json: { status: 200, result: 'true' } and return if params[:id] == session.id.to_s

      render json: { status: 200, result: 'false' }
    end
    # rubocop:enable Style/AndOr

    def index
      redirect_to facilities_management_path if user_signed_in?
    end
  end
end
