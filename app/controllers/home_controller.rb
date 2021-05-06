class HomeController < ApplicationController
  before_action :authenticate_user!, :validate_service, except: %i[status index not_permitted]

  def index
    redirect_to ccs_homepage_url
  end

  def status
    render layout: false
  end

  def not_permitted
    if crown_marketplace_service?
      if service_name == 'auth'
        redirect_to '/supply-teachers/not-permitted'
      else
        redirect_to "/#{service_name}/not-permitted"
      end
    else
      redirect_to errors_404_path
    end
  end

  private

  CROWN_MARKETPLACE_SERVICES = %w[auth facilities_management legal_services management_consultancy supply_teachers crown_marketplace].freeze

  def service_name
    @service_name ||= params[:service].gsub('_', '-')
  end

  def crown_marketplace_service?
    CROWN_MARKETPLACE_SERVICES.include? params[:service]
  end
end
