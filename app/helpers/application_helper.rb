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

  def govuk_form_group_with_optional_error(journey)
    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if journey.error.present?

    content_tag :div, class: css_classes.join(' ') do
      yield
    end
  end

  def display_error(journey)
    return if journey.error.blank?

    content_tag :span, class: 'govuk-error-message' do
      journey.error
    end
  end
end
