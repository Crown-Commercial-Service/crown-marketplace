module FacilitiesManagement::ProcurementDetailsConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_procurement
    before_action :authorize_user
    before_action :redirect_if_unrecognised_section, only: :show
    before_action :redirect_to_edit_from_show, only: :show
    before_action :redirect_if_unrecognised_edit_section, only: :edit
  end

  def show
    render 'facilities_management/shared/details/show'
  end

  def edit
    render 'facilities_management/shared/details/edit'
  end

  def update; end

  private

  def section
    @section ||= params['section'].underscore
  end

  def section_status
    @section_status ||= @procurement.send("#{section}_status")
  end

  def redirect_if_unrecognised_section
    redirect_to "/facilities-management/#{params[:framework]}/procurements/#{params[:procurement_id]}" unless self.class::RECOGNISED_DETAILS_SHOW_PAGES.include? section
  end

  def redirect_to_edit_from_show
    redirect_to "/facilities-management/#{params[:framework]}/procurements/#{params[:procurement_id]}/details/#{params[:section]}/edit" if section_status == :not_started || (section == 'contract_period' && section_status == :incomplete)
  end

  def redirect_if_unrecognised_edit_section
    redirect_to "/facilities-management/#{params[:framework]}/procurements/#{params[:procurement_id]}" unless self.class::RECOGNISED_DETAILS_EDIT_STEPS.include? section
  end

  protected

  def authorize_user
    @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
  end
end
