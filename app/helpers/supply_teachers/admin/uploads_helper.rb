module SupplyTeachers::Admin::UploadsHelper
  def css_classes_for_file_upload(journey, attribute, extra_classes = [])
    error = journey.errors[attribute].first

    css_classes = ['govuk-file-upload'] + extra_classes
    css_classes += %w[govuk-input--error govuk-input] if error.present?
    css_classes
  end
end
