class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    suppliers = JSON.parse(request.body.read)

    error = Upload.create(suppliers)

    raise error if error

    render json: {}, status: :created
  end
end
