module FacilitiesManagement::Admin::FrameworkStatusConcern
  extend ActiveSupport::Concern

  included do
    before_action :raise_if_unrecognised_framework

    rescue_from ApplicationController::UnrecognisedFrameworkError do
      @unrecognised_framework = params[:framework]
      params[:framework] = Framework.facilities_management.current_framework

      render 'facilities_management/admin/home/unrecognised_framework', status: :bad_request
    end
  end

  protected

  def raise_if_unrecognised_framework
    raise ApplicationController::UnrecognisedFrameworkError, 'Unrecognised Framework' unless Framework.facilities_management.recognised_framework? params[:framework]
  end
end
