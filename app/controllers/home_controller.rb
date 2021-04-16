class HomeController < ApplicationController
  before_action :authenticate_user!, except: %i[status index not_permitted]

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
      redirect_to '/404'
    end
  end

  private

  CROWN_MARKETPLACE_SERVICES = %w[auth facilities_management legal_services management_consultancy supply_teachers].freeze

  def service_name_param
    @service_name_param ||= params[:service].nil? ? request&.controller_class&.module_parent_name&.underscore : params[:service]
  end

  def service_name
    @service_name ||= service_name_param.gsub('_', '-')
  end

  def crown_marketplace_service?
    CROWN_MARKETPLACE_SERVICES.include? service_name_param
  end
end
