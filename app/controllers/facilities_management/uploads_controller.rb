class FacilitiesManagement::UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    suppliers = JSON.parse(request.body.read)

    FacilitiesManagement::Upload.create!(suppliers)

    render json: {}, status: :created
  end
end
