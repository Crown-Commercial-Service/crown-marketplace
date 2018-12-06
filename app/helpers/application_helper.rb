module ApplicationHelper
  def miles_to_metres(miles)
    DistanceConverter.miles_to_metres(miles)
  end

  def metres_to_miles(metres)
    DistanceConverter.metres_to_miles(metres)
  end

  def feedback_email_link
    govuk_email_link(
      Marketplace.feedback_email_address,
      t('layouts.application.feedback_aria_label'),
      css_class: 'govuk-link ga-feedback-mailto'
    )
  end

  def support_email_link(label)
    govuk_email_link(
      Marketplace.support_email_address,
      label,
      css_class: 'govuk-link ga-support-mailto'
    )
  end

  def govuk_email_link(email_address, aria_label, css_class: 'govuk-link')
    mail_to(email_address, email_address, class: css_class, 'aria-label': aria_label)
  end

  def govuk_form_group_with_optional_error(journey, *attributes)
    attributes_with_errors = attributes.select { |a| journey.errors[a].any? }

    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if attributes_with_errors.any?

    content_tag :div, class: css_classes do
      yield
    end
  end

  def govuk_fieldset_with_optional_error(journey, *attributes)
    attributes_with_errors = attributes.select { |a| journey.errors[a].any? }

    options = { class: 'govuk-fieldset' }
    options['aria-describedby'] = attributes_with_errors.map { |a| error_id(a) } if attributes_with_errors.any?

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

  def link_to_service_start_page
    return unless controller.class.parent_name

    render partial: "#{controller.class.parent_name.underscore}/link_to_start_page"
  end
end
