# rubocop:disable Metrics/ModuleLength
module FacilitiesManagement::ProcurementDetailsConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_procurement
    before_action :authorize_user
    before_action :redirect_if_unrecognised_section, only: :show
    before_action :redirect_to_edit_from_show, only: :show
    before_action :set_procurement_show_data, only: :show
    before_action :redirect_if_unrecognised_edit_section, only: :edit
    before_action :set_procurement_edit_data, only: :edit

    helper_method :section, :edit_path, :procurement_show_path
  end

  def show
    render 'facilities_management/shared/details/show'
  end

  def edit
    render 'facilities_management/shared/details/edit'
  end

  def update
    assign_procurement_attributes

    if section == :buildings && !params[:commit]
      paginate_procurement_buildings
    elsif @procurement.save(context: section.to_sym)
      redirect_to(self.class::RECOGNISED_DETAILS_SHOW_PAGES.include?(section) ? show_path : procurement_show_path)
    else
      set_paginated_buildings_data if section == :buildings

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

  def set_procurement_edit_data
    @procurement.build_call_off_extensions if section == :contract_period
    set_buildings if section == :buildings
  end

  def set_procurement_show_data
    @active_procurement_buildings = @procurement.procurement_buildings.where(active: true).order_by_building_name.page(params[:page]) if section == :buildings
  end

  # Methods relating to paginating the buildings
  def set_buildings
    find_buildings_with_update
    set_paginated_buildings_data
  end

  def find_buildings_with_update
    @building_params ||= {}
    active_procurement_building_ids = @procurement.procurement_buildings.select(&:active).pluck(:building_id)

    active_procurement_building_ids.each do |building_id|
      @building_params[building_id] = '1' unless @building_params[building_id]
    end

    @building_params.select! { |building_id, active| active == '1' || active_procurement_building_ids.include?(building_id) }
  end

  def set_paginated_buildings_data
    @buildings = current_user.buildings.order_by_building_name.page(params[:page])
    visible_buildings_ids = @buildings.map(&:id)

    hidden_building_ids = @building_params.reject { |building_id, _| visible_buildings_ids.include? building_id }.keys
    @hidden_buildings = current_user.buildings.order_by_building_name.where(id: hidden_building_ids)
  end

  def paramatise_building_selection
    @building_params = procurement_params['procurement_buildings_attributes'].to_h.values.select { |building| building['active'] }.map { |item| [item['building_id'], item['active']] }.to_h
  end

  def paginate_procurement_buildings
    params[:page] = params.keys.select { |key| key.include?('paginate') }.first.split('-').last

    set_paginated_buildings_data

    render 'facilities_management/shared/details/edit'
  end

  # Methods relating to assigning attributes
  def assign_procurement_attributes
    if section == :buildings
      paramatise_building_selection
      find_buildings_with_update

      return unless params[:commit]

      current_procurement_buildings = @procurement.procurement_buildings.select(:id, :building_id).map { |pb| [pb.building_id, pb.id] }.to_h
      @procurement.assign_attributes(procurement_buildings_attributes: @building_params.map { |building_id, active| { id: current_procurement_buildings[building_id], building_id: building_id, active: active } })
    else
      @procurement.assign_attributes(procurement_params)
    end
  end

  def procurement_params
    if params[@procurement.model_name.param_key]
      params.require(@procurement.model_name.param_key).permit(PERMITED_PARAMS[section])
    else
      @procurement.service_codes = [] if section == :services
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
    ],
    services: [service_codes: []],
    buildings: [procurement_buildings_attributes: %i[building_id active]]
  }.freeze

  protected

  def authorize_user
    @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
  end
end
# rubocop:enable Metrics/ModuleLength
