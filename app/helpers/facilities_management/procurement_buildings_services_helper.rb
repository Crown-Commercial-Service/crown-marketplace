module FacilitiesManagement::ProcurementBuildingsServicesHelper
  def specific_lift_error?(model, error_type, index)
    model.errors.details[:lift_data].find_index { |item| item[:position] == index && item[:error] == error_type }.present?
  end

  def any_lift_error?(model, index)
    model.errors.details[:lift_data].find_index { |item| item[:position] == index }.present?
  end

  def all_not_required?(service_hours)
    service_hours.errors.details[:base].any? && service_hours.errors.details[:base].first[:error] == :required
  end

  def error_summary_link(key, value, attribute)
    link_to value.errors[attribute].first.to_s, "##{key}-#{attribute}-error", data: { fieldname: :service_choice, errortype: value.errors.details[attribute].first[:error] }
  end
end
