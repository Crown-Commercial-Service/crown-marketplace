module Admin::SupplierActions
  extend ActiveSupport::Concern

  include Admin::SupplierPathsConcern

  included do
    before_action :authenticate_user!, :authorize_user
    before_action :set_supplier_frameworks, only: %i[index]
    before_action :set_supplier_framework, only: %i[show edit update]
    before_action :set_section, :set_model, :set_section_attributes, only: %i[edit update]

    helper_method :service, :current_supplier_name
  end

  def index
    render template: 'shared/admin/suppliers/index'
  end

  def show
    render template: 'shared/admin/suppliers/show'
  end

  def edit
    render template: 'shared/admin/suppliers/edit'
  end

  def update
    @model.assign_attributes(model_params)

    model_saved = ActiveRecord::Base.transaction do
      @model.save!(context: @section)
      ChangeLog.public_send(:"log_#{self.class::SECTION_TO_CHANGE_TYPE[@section]}!", user: current_user, framework: params[:framework], model: @model)

      true
    rescue ActiveRecord::RecordInvalid => e
      unless @model.errors.any?
        Rails.logger.error e
        Rollbar.log('error', e)

        @model.errors.add(:base, :something_went_wrong)
      end

      false
    end

    if model_saved
      redirect_to action: :show
    else
      render template: 'shared/admin/suppliers/edit'
    end
  end

  private

  def authorize_user
    authorize! :manage, service.module_parent::Admin
  end

  def service
    @service ||= self.class.module_parent.module_parent
  end

  def set_supplier_frameworks
    @supplier_frameworks = Supplier::Framework.includes(:supplier).where(framework: params[:framework]).order('supplier.name')
  end

  def set_supplier_framework
    @supplier_framework = Supplier::Framework.includes(:supplier, :contact_detail).find(params.expect(:id))
  end

  def set_section
    @section = params.expect(:section).to_sym

    redirect_to action: :show unless self.class::SECTION_TO_PARAMS.include?(@section)
  end

  def set_model
    @model = case @section
             when :basic_supplier_information
               service::Admin::Supplier.find(@supplier_framework.supplier_id)
             when :supplier_contact_information, :additional_supplier_information
               service::Admin::SupplierContactDetail.find_by(supplier_framework_id: @supplier_framework.id)
             end
  end

  def set_section_attributes
    @section_attributes = section_attributes(@section)
  end

  def model_params
    params[@model.model_name.param_key].present? ? params.expect("#{@model.model_name.param_key}": @section_attributes) : {}
  end

  def current_supplier_name
    Supplier::Framework.find(params.expect(:id)).supplier_name
  end
end
