# rubocop:disable Metrics/ModuleLength
module Admin::LotDataActions
  extend ActiveSupport::Concern

  include Admin::SupplierPathsConcern

  included do
    before_action :authenticate_user!, :authorize_user
    before_action :set_framework, :set_supplier_framework
    before_action :set_supplier_framework_lots, :set_supplier_lot_data, only: :index
    before_action :set_lot, :set_supplier_framework_lot, only: %i[show edit update]
    before_action :set_section_for_show, only: :show
    before_action :set_section_for_edit, :set_model, only: %i[edit update]
    before_action :set_section_data, :set_supplier_framework_lot_data, only: %i[show edit update]

    helper_method :service
  end

  def index
    render template: 'shared/admin/lot_data/index'
  end

  def show
    render template: 'shared/admin/lot_data/show'
  end

  def edit
    render template: 'shared/admin/lot_data/edit'
  end

  def update
    if send(:"update_for_#{@section}")
      if @section == :lot_status
        redirect_to action: :index
      else
        redirect_to action: :show, section: @section
      end
    else
      render template: 'shared/admin/lot_data/edit'
    end
  end

  private

  def set_framework
    @framework = Framework.find(params.expect(:framework))
  end

  # rubocop:disable Rails/DynamicFindBy
  def set_lot
    @lot = @framework.lots.find_by_number_as_slug(params[:lot_number])
  end
  # rubocop:enable Rails/DynamicFindBy

  def set_supplier_framework
    @supplier_framework = Supplier::Framework.includes(:supplier).find(params.expect(:supplier_id))
  end

  def set_supplier_framework_lots
    @supplier_framework_lots = @supplier_framework.lots.index_by(&:lot_id)
  end

  def set_supplier_framework_lot
    @supplier_framework_lot = @supplier_framework.lots.find_by(lot_id: @lot.id)
  end

  def set_supplier_lot_data
    @supplier_lot_data = @framework.lots.order(self.class::LOT_SORT_CRITERIA).map do |lot|
      {
        lot: {
          number: lot.number,
          number_as_slug: lot.number_as_slug,
          name: lot.name
        },
        enabled: @supplier_framework_lots.key?(lot.id) ? @supplier_framework_lots[lot.id].enabled : nil,
        sections: lot_sections(lot)
      }
    end
  end

  def set_supplier_framework_lot_data
    return if @section == :lot_status

    send(:"set_supplier_framework_lot_data_for_#{@section}")
  end

  def set_section_for_show
    @section = params.expect(:section).to_sym

    redirect_to action: :index unless self.class::SECTIONS_TO_SHOW.include?(@section)
  end

  def set_section_for_edit
    @section = params.expect(:section).to_sym

    redirect_to action: :show, section: @section unless self.class::SECTIONS_TO_EDIT.include?(@section)
  end

  def set_section_data
    case @section
    when :services
      @services = @lot.services_grouped_by_category
    end
  end

  def set_model
    @model = case @section
             when :lot_status, :services, :jurisdictions, :rates
               @supplier_framework_lot
             when :branches
               @supplier_framework_lot.branches.find(params.expect(:branch_id))
             end
  end

  def set_supplier_framework_lot_data_for_services
    @supplier_framework_lot_service_ids = @supplier_framework_lot.services.pluck(:service_id)
  end

  def set_supplier_framework_lot_data_for_jurisdictions
    @supplier_framework_lot_jurisdiction_ids = @supplier_framework_lot.jurisdictions.pluck(:jurisdiction_id)
  end

  def set_supplier_framework_lot_data_for_rates
    @supplier_framework_lot_rates = if action_name.to_sym == :show
                                      @supplier_framework.grouped_rates_for_lot(@lot.id)
                                    else
                                      @supplier_framework_lot_jurisdiction = @supplier_framework_lot.jurisdictions.find_by(jurisdiction_id: params.fetch(:jurisdiction_id, "#{@framework.id}.GB"))
                                      supplier_framework_lot_rates = @supplier_framework.grouped_rates_for_lot_and_jurisdictions(@lot.id, [@supplier_framework_lot_jurisdiction.jurisdiction_id])
                                      @lot.positions.pluck(:id).index_with { |position_id| (supplier_framework_lot_rates[position_id] && supplier_framework_lot_rates[position_id][@supplier_framework_lot_jurisdiction.jurisdiction_id]) || @supplier_framework_lot.rates.build(position_id: position_id, supplier_framework_lot_jurisdiction_id: @supplier_framework_lot_jurisdiction.id) }
                                    end
  end

  def set_supplier_framework_lot_data_for_branches
    @supplier_framework_lot_branches = @supplier_framework_lot.branches.order(:name)
  end

  def update_for_lot_status
    new_attributes = params[@model.model_name.param_key].present? ? params.expect("#{@model.model_name.param_key}": %i[enabled]) : {}

    @model.assign_attributes(new_attributes)

    ActiveRecord::Base.transaction do
      @model.save!(context: @section)
      ChangeLog.log_update_supplier_framework_lot_status!(user: current_user, framework: params[:framework], model: @model)

      true
    rescue ActiveRecord::RecordInvalid => e
      unless @model.errors.any?
        Rails.logger.error e
        Rollbar.log('error', e)

        @model.errors.add(:base, :something_went_wrong)
      end

      false
    end
  end

  # rubocop:disable Metrics/AbcSize, Naming/PredicateMethod
  def update_for_services
    service_ids = (params[@model.model_name.param_key].present? ? params.expect("#{@model.model_name.param_key}": { service_ids: [] }) : {})[:service_ids] || []

    service_ids_to_add = service_ids - @supplier_framework_lot_service_ids
    service_ids_to_remove = @supplier_framework_lot_service_ids - service_ids

    ActiveRecord::Base.transaction do
      @model.services.where(service_id: service_ids_to_remove).find_each(&:destroy!)
      @model.services.build(service_ids_to_add.map { |service_id| { service_id: } }).each(&:save!)
      ChangeLog.log_update_supplier_framework_lot_services!(user: current_user, framework: params[:framework], model: @model, added: service_ids_to_add, removed: service_ids_to_remove)
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error e
      Rollbar.log('error', e)
      @model.errors.add(:base, :service_update_invalid)
    end

    @model.errors.none?
  end

  def update_for_jurisdictions
    jurisdiction_ids = (params[@model.model_name.param_key].present? ? params.expect("#{@model.model_name.param_key}": { jurisdiction_ids: [] }) : {})[:jurisdiction_ids] || []

    jurisdiction_ids_to_add = jurisdiction_ids - @supplier_framework_lot_jurisdiction_ids
    jurisdiction_ids_to_remove = @supplier_framework_lot_jurisdiction_ids - jurisdiction_ids

    ActiveRecord::Base.transaction do
      @model.jurisdictions.where(jurisdiction_id: jurisdiction_ids_to_remove).find_each(&:destroy!)
      @model.jurisdictions.build(jurisdiction_ids_to_add.map { |jurisdiction_id| { jurisdiction_id: } }).each(&:save!)
      ChangeLog.log_update_supplier_framework_lot_jurisdictions!(user: current_user, framework: params[:framework], model: @model, added: jurisdiction_ids_to_add, removed: jurisdiction_ids_to_remove)
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error e
      Rollbar.log('error', e)
      @model.errors.add(:base, :jurisdiction_update_invalid)
    end

    @model.errors.none?
  end
  # rubocop:enable Metrics/AbcSize, Naming/PredicateMethod

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Naming/PredicateMethod
  def update_for_rates
    rates = (params[@model.model_name.param_key].present? ? params.expect("#{@model.model_name.param_key}": { rates: @lot.positions.pluck(:id).map(&:to_sym) }) : {})[:rates] || {}

    valid_rates = @supplier_framework_lot_rates.map do |position_id, supplier_framework_lot_rate|
      supplier_framework_lot_rate.assign_rate_and_validate?(rates[position_id])
    end

    if valid_rates.all?
      ActiveRecord::Base.transaction do
        @supplier_framework_lot_rates.each_value do |supplier_framework_lot_rate|
          if supplier_framework_lot_rate.rate.nil?
            next unless supplier_framework_lot_rate.persisted?

            # We need to reload the rate so that the change log can register what the rate was before it was deleted
            supplier_framework_lot_rate.reload
            supplier_framework_lot_rate.destroy!
          else
            supplier_framework_lot_rate.save!
          end
        end
        ChangeLog.log_update_supplier_framework_lot_rates!(user: current_user, framework: params[:framework], model: @model, rates: @supplier_framework_lot_rates)
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error e
        Rollbar.log('error', e)
        @supplier_framework_lot_rates.each_value do |supplier_framework_lot_rate|
          supplier_framework_lot_rate.errors.add(:rate, :update_invalid)
        end
      end

      true
    else
      false
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Naming/PredicateMethod

  def update_for_branches
    new_attributes = params[@model.model_name.param_key].present? ? params.expect("#{@model.model_name.param_key}": %i[name region contact_name contact_email telephone_number address_line_1 address_line_2 town county postcode]) : {}

    @model.assign_attributes(new_attributes)

    ActiveRecord::Base.transaction do
      @model.save!(context: @section)
      ChangeLog.log_update_supplier_framework_lot_branch!(user: current_user, framework: params[:framework], model: @model)

      true
    rescue ActiveRecord::RecordInvalid => e
      unless @model.errors.any?
        Rails.logger.error e
        Rollbar.log('error', e)

        @model.errors.add(:base, :something_went_wrong)
      end

      false
    end
  end

  def authorize_user
    authorize! :manage, service.module_parent::Admin
  end

  def service
    @service ||= self.class.module_parent.module_parent
  end
end
# rubocop:enable Metrics/ModuleLength
