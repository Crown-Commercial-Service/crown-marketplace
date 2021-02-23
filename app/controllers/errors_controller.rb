class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.html { render status: :not_found, layout: 'error' }
    end
  end

  def unacceptable
    respond_to do |format|
      format.html { render status: :unprocessable_entity, layout: 'error' }
    end
  end

  def internal_error
    respond_to do |format|
      format.html { render status: :internal_server_error, layout: 'error' }
    end
  end

  def service_unavailable
    respond_to do |format|
      format.html { render status: :service_unavailable, layout: 'error' }
    end
  end
end
