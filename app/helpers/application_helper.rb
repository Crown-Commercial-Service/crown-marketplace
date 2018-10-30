module ApplicationHelper
  def miles_to_metres(miles)
    DistanceConvertor.miles_to_metres(miles)
  end

  def metres_to_miles(metres)
    DistanceConvertor.metres_to_miles(metres)
  end

  def feedback_email_link
    if Marketplace.feedback_email_address.present?
      mail_to(Marketplace.feedback_email_address, 'feedback', class: 'govuk-link')
    else
      'feedback'
    end
  end

  def govuk_form_group_with_optional_error(journey, attribute)
    error = journey.errors[attribute].first

    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if error.present?

    content_tag :div, class: css_classes do
      yield
    end
  end

  def display_error(journey, attribute)
    error = journey.errors[attribute].first
    return if error.blank?

    content_tag :span, id: "#{attribute}-error", class: 'govuk-error-message' do
      error
    end
  end

  def css_classes_for_input(journey, attribute, extra_classes = [])
    error = journey.errors[attribute].first

    css_classes = ['govuk-input'] + extra_classes
    css_classes += ['govuk-input--error'] if error.present?
    css_classes
  end
end
