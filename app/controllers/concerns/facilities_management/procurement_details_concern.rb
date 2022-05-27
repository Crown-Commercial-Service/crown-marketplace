module FacilitiesManagement::ProcurementDetailsConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_procurement
    before_action :authorize_user
    before_action :redirect_if_unrecognised_section, only: :show
    before_action :redirect_to_edit_from_show, only: :show
    before_action :redirect_if_unrecognised_edit_section, only: :edit
    before_action :set_procurement_data, only: :edit

    helper_method :section, :edit_path, :procurement_show_path
  end

  def show
    render 'facilities_management/shared/details/show'
  end

  def edit
    render 'facilities_management/shared/details/edit'
  end

  def update
    @procurement.assign_attributes(procurement_params)

    if @procurement.save(context: section.to_sym)
      redirect_to(self.class::RECOGNISED_DETAILS_SHOW_PAGES.include?(section) ? show_path : procurement_show_path)
    else
      render 'facilities_management/shared/details/edit'
    end
  end

  private

  def section
    @section ||= params['section'].underscore.to_sym
  end

  def section_status
    @section_status ||= @procurement.send("#{section}_status")
  end

  def redirect_if_unrecognised_section
    redirect_to procurement_show_path unless self.class::RECOGNISED_DETAILS_SHOW_PAGES.include? section
  end

  def redirect_to_edit_from_show
    redirect_to edit_path if section_status == :not_started || (section == :contract_period && section_status == :incomplete)
  end

  def redirect_if_unrecognised_edit_section
    redirect_to procurement_show_path unless self.class::RECOGNISED_DETAILS_EDIT_STEPS.include? section
  end

  def procurement_show_path
    "/facilities-management/#{params[:framework]}/procurements/#{params[:procurement_id]}"
  end

  def show_path
    "/facilities-management/#{params[:framework]}/procurements/#{params[:procurement_id]}/details/#{params[:section]}"
  end

  def edit_path
    "/facilities-management/#{params[:framework]}/procurements/#{params[:procurement_id]}/details/#{params[:section]}/edit"
  end

  def set_procurement_data
    @procurement.build_call_off_extensions if section == :contract_period
  end

  def procurement_params
    if params[@procurement.model_name.param_key]
      params.require(@procurement.model_name.param_key).permit(PERMITED_PARAMS[section])
    else
      {}
    end
  end

  PERMITED_PARAMS = {
    contract_name: [:contract_name],
    annual_contract_value: [:annual_contract_value],
    tupe: [:tupe],
    contract_period: [
      :initial_call_off_start_date_dd,
      :initial_call_off_start_date_mm,
      :initial_call_off_start_date_yyyy,
      :initial_call_off_period_years,
      :initial_call_off_period_months,
      :mobilisation_period_required,
      :mobilisation_period,
      :extensions_required,
      { call_off_extensions_attributes: %i[id extension years months extension_required] }
    ]
  }.freeze

  protected

  def authorize_user
    @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
  end
end
