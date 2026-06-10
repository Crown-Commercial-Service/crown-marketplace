module Admin::SupplierPathsConcern
  extend ActiveSupport::Concern

  included do
    helper_method :suppliers_index_path,
                  :supplier_show_path,
                  :supplier_edit_path,
                  :supplier_update_path,
                  :supplier_lot_data_index_path,
                  :supplier_lot_data_show_path,
                  :supplier_lot_data_edit_path,
                  :supplier_lot_data_update_path,
                  :supplier_uploads_index_path,
                  :supplier_uploads_new_path,
                  :supplier_uploads_show_path,
                  :supplier_change_logs_index_path,
                  :supplier_change_logs_show_path,
                  :user_reports_index_path,
                  :user_reports_new_path,
                  :user_reports_show_path,
                  :framework_show_path,
                  :framework_edit_path,
                  :framework_update_path
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

  def supplier_uploads_index_path
    uploads_path(service_name, params[:framework])
  end

  def supplier_uploads_new_path
    new_upload_path(service_name, params[:framework])
  end

  def supplier_uploads_show_path(upload_id)
    upload_path(service_name, params[:framework], upload_id)
  end

  def supplier_change_logs_index_path
    change_logs_path(service_name, params[:framework])
  end

  def supplier_change_logs_show_path(change_log)
    change_log_path(service_name, params[:framework], change_log.id)
  end

  def user_reports_index_path
    reports_path(service_name, params[:framework])
  end

  def user_reports_new_path
    new_report_path(service_name, params[:framework])
  end

  def user_reports_show_path(report_id)
    report_path(service_name, params[:framework], report_id)
  end

  def framework_show_path
    frameworks_path(service_name, params[:framework])
  end

  def framework_edit_path
    frameworks_edit_path(service_name, params[:framework])
  end

  def service_name
    @service_name ||= params.expect(:service).split('/').first.dasherize
  end
end
