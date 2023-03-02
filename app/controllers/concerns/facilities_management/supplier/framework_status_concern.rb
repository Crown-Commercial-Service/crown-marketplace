module FacilitiesManagement::Supplier::FrameworkStatusConcern
  extend ActiveSupport::Concern

  included do
    before_action :raise_if_not_live_framework

    rescue_from ApplicationController::UnrecognisedLiveFrameworkError do
      redirect_to facilities_management_index_path(framework: Framework.facilities_management.current_framework)
    end
  end

  protected

  def raise_if_not_live_framework
    raise ApplicationController::UnrecognisedLiveFrameworkError, 'Unrecognised Live Framework' unless Framework.facilities_management.live_framework?(params[:framework])
  end
end
