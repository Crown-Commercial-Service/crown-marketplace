class ErrorsController < ApplicationController
  layout 'error'

  before_action :authenticate_user!, :authorize_user, :validate_service, except: %i[not_found unacceptable internal_error service_unavailable]
  before_action -> { request.format = :html }

  def not_found
    render status: :not_found
  end

  def not_acceptable
    render status: :not_acceptable
  end

  def unacceptable
    render status: :unprocessable_entity
  end

  def internal_error
    render status: :internal_server_error
  end

  def service_unavailable
    render status: :service_unavailable
  end
end
