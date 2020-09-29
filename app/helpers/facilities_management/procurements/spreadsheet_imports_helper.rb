module FacilitiesManagement::Procurements::SpreadsheetImportsHelper
  def error_count(error_list, attribute)
    case attribute
    when :service_matrix_errors
      error_list.sum { |e| e[:errors].count }
    else
      error_list.count
    end
  end

  def error_message(model, attribute, message)
    t("facilities_management.procurements.spreadsheet_imports.errors.#{model}.#{attribute}.#{message}")
  end
end
