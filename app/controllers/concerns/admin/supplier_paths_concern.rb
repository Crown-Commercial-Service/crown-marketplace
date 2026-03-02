module Admin::SupplierPathsConcern
  extend ActiveSupport::Concern

  included do
    helper_method :suppliers_index_path, :supplier_show_path, :supplier_edit_path, :supplier_update_path, :supplier_lot_data_index_path, :supplier_lot_data_show_path, :supplier_lot_data_edit_path, :supplier_lot_data_update_path, :change_logs_index_path
  end

  private

  def suppliers_index_path
    suppliers_path(service_name, params[:framework])
  end

  def supplier_show_path(supplier_framework)
    supplier_path(service_name, params[:framework], supplier_framework)
  end

  def supplier_edit_path(supplier_framework, section)
    edit_supplier_path(service_name, params[:framework], supplier_framework, section:)
  end

  def supplier_update_path(supplier_framework, section)
    supplier_path(service_name, params[:framework], supplier_framework, section:)
  end

  def supplier_lot_data_index_path(supplier_framework)
    supplier_lot_data_path(service_name, params[:framework], supplier_framework.id)
  end

  def supplier_lot_data_show_path(supplier_framework, lot_number, section)
    supplier_lot_datum_path(service_name, params[:framework], supplier_framework.id, lot_number, section:)
  end

  def supplier_lot_data_edit_path(supplier_framework, lot_number, section, **)
    edit_supplier_lot_datum_path(service_name, params[:framework], supplier_framework.id, lot_number, section:, **)
  end

  def supplier_lot_data_update_path(supplier_framework, lot_number, section, **)
    supplier_lot_datum_path(service_name, params[:framework], supplier_framework.id, lot_number, section:, **)
  end

  def change_logs_index_path
    change_logs_path(service_name, params[:framework])
  end

  def service_name
    @service_name ||= params[:service].split('/').first.dasherize
  end
end
