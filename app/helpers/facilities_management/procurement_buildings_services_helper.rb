module FacilitiesManagement::ProcurementBuildingsServicesHelper
  def specific_lift_error?(model, error_type, index)
    model.errors.details[:lift_data].find_index { |item| item[:position] == index && item[:error] == error_type }.present?
  end

  def any_lift_error?(model, index)
    model.errors.details[:lift_data].find_index { |item| item[:position] == index }.present?
  end

  def form_group_with_error(model, attribute)
    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if model.errors.key?(attribute)

    content_tag :div, class: css_classes do
      yield
    end
  end
end
