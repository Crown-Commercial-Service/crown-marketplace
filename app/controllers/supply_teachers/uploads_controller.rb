module SupplyTeachers
  class UploadsController < FrameworkController
    skip_before_action :verify_authenticity_token, only: :create
    require_permission :none, only: :create

    if Rails.env.production?
      http_basic_authenticate_with(
        name: ENV.fetch('HTTP_BASIC_AUTH_NAME'),
        password: ENV.fetch('HTTP_BASIC_AUTH_PASSWORD')
      )
    end

    def create
      suppliers = JSON.parse(request.body.read)

      Upload.upload!(suppliers)

      render json: {}, status: :created
    end
  end
end
