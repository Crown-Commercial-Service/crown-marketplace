module SupplyTeachers
  class UploadsController < FrameworkController
    skip_before_action :verify_authenticity_token, only: :create
    require_permission :none, only: :create

    if Rails.env.production?
      http_basic_authenticate_with(
        name: Marketplace.http_basic_auth_name,
        password: Marketplace.http_basic_auth_password
      )
    end

    def create
      suppliers = JSON.parse(request.body.read)

      Upload.upload!(suppliers)

      render json: {}, status: :created
    end
  end
end
