class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :require_login, only: :create

  if Rails.env.production?
    http_basic_authenticate_with(
      name: ENV.fetch('HTTP_BASIC_AUTH_NAME'),
      password: ENV.fetch('HTTP_BASIC_AUTH_PASSWORD')
    )
  end

  def create
    suppliers = JSON.parse(request.body.read)

    Upload.create!(suppliers)

    render json: {}, status: :created
  end
end
