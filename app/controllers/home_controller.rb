class HomeController < ApplicationController
  before_action :authenticate_user!, :validate_service, except: %i[healthcheck index]

  def index
    @frameworks = Framework.live_framework_records.order(:live_at)
  end

  def healthcheck
    render json: { status: :ok, git_commit: ENV.fetch('GIT_COMMIT', '') }
  end
end
