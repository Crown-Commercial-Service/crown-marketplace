module SupplyTeachers::Admin::UploadsHelper
  def css_classes_for_file_upload(journey, attribute, extra_classes = [])
    error = journey.errors[attribute].first

    css_classes = ['govuk-file-upload'] + extra_classes
    css_classes += %w[govuk-input--error govuk-input] if error.present?
    css_classes
  end

  def warning_details(uploads)
    uploads_more_than_one = uploads.count > 1
    "Upload session #{uploads.map(&:short_uuid).to_sentence} #{uploads_more_than_one ? 'are' : 'is'} #{uploads.map { |u| t("supply_teachers.admin.uploads.index.#{u.aasm_state}") }.to_sentence.downcase}. Uploading new spreadsheets will cancel #{uploads_more_than_one ? 'those sessions' : 'that session'}."
  end
end
