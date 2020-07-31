class HomeController < ApplicationController
  before_action :authenticate_user!, except: %i[status index cookies landing_page accessibility_statement_fm accessibility_statement_mc accessibility_statement_ls not_permitted]

  def index
    redirect_to ccs_homepage_url
  end

  def status
    render layout: false
  end

  def cookies; end

  def landing_page; end

  def accessibility_statement_fm
    params[:service] = 'facilities_management' if params[:service].nil?
  end

  def accessibility_statement_mc
    params[:service] = 'management_consultancy' if params[:service].nil?
  end

  def accessibility_statement_ls
    params[:service] = 'legal_services' if params[:service].nil?
  end

  def not_permitted
    @service = params[:service]
  end
end
