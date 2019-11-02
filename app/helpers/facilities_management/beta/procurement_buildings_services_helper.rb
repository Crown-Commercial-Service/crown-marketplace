module FacilitiesManagement::Beta::ProcurementBuildingsServicesHelper
  def specific_lift_error?(model, error_type, index)
    model.errors.details[:lift_data].find_index { |item| item[:position] == index && item[:error] == error_type }.present?
  end

  def any_lift_error?(model, index)
    model.errors.details[:lift_data].find_index { |item| item[:position] == index }.present?
  end

  def error_for_lift(model, index)
    error_position = model.errors.details[:lift_data].find_index { |item| item[:position] == index }
    return model.errors[:lift_data][error_position] unless error_position.nil?

    '' if error_position.nil?
  end
end
