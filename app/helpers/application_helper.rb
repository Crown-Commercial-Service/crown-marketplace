module ApplicationHelper
  def miles_to_metres(miles)
    DistanceConvertor.miles_to_metres(miles)
  end

  def metres_to_miles(metres)
    DistanceConvertor.metres_to_miles(metres)
  end

  def feedback_email_link
    if Marketplace.feedback_email_address.present?
      mail_to(
        Marketplace.feedback_email_address, 'feedback',
        class: 'govuk-link', 'aria-label': t('layouts.application.feedback_aria_label')
      )
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

  def govuk_fieldset_with_optional_error(journey, attribute)
    error = journey.errors[attribute].first

    options = { class: 'govuk-fieldset' }
    options['aria-describedby'] = error_id(attribute) if error.present?

    content_tag :fieldset, options do
      yield
    end
  end

  def display_error(journey, attribute)
    error = journey.errors[attribute].first
    return if error.blank?

    content_tag :span, id: error_id(attribute), class: 'govuk-error-message' do
      error
    end
  end

  def css_classes_for_input(journey, attribute, extra_classes = [])
    error = journey.errors[attribute].first

    css_classes = ['govuk-input'] + extra_classes
    css_classes += ['govuk-input--error'] if error.present?
    css_classes
  end

  def error_id(attribute)
    "#{attribute}-error"
  end

  def page_title
    optional_prefix = content_for(:page_title_prefix)
    [optional_prefix, t('layouts.application.title')].reject(&:blank?).map(&:strip).join(': ')
  end

  def add_optional_error_prefix_to_page_title(errors)
    return if errors.empty?

    content_for(:page_title_prefix) { t('layouts.application.error_prefix') }
  end

  def hidden_fields_for_previous_steps_and_responses(journey)
    html = ActiveSupport::SafeBuffer.new
    journey.previous_questions_and_answers.each do |(key, value)|
      if value.is_a? Array
        value.each do |v|
          html += hidden_field_tag("#{key}[]", v, id: nil)
        end
      else
        html += hidden_field_tag(key, value)
      end
    end
    html
  end
end
