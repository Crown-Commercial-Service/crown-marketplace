# rubocop:disable Metrics/ModuleLength
module LayoutHelper
  include ErrorsHelper

  # Module to render page elements
  # field-sets and input groups
  # errors

  # Value Objects (Classes) to structure data for parameters to helper methods
  class NavigationDetail
    attr_accessor(:primary_text, :return_url, :return_text, :secondary_url, :secondary_text)

    def initialize(primary_text, return_url, return_text, secondary_url, secondary_text)
      @primary_text = primary_text
      @return_url = return_url
      @return_text = return_text
      @secondary_url = secondary_url
      @secondary_text = secondary_text
    end
  end

  class BackButtonDetail
    attr_accessor(:url, :text, :label)

    def initialize(back_url, back_label, back_text)
      @url = back_url
      @label = back_label
      @text = back_text
    end
  end

  class HeadingDetail
    attr_accessor(:text, :caption, :caption2, :subtitle)

    def initialize(header_text, caption1, caption2, sub_text)
      @text = header_text
      @caption = caption1
      @caption2 = caption2
      @subtitle = sub_text
    end

    def caption?
      @caption.present? || caption2.present?
    end
  end

  class PageDescription
    attr_accessor(:heading_details, :back_button, :navigation_details)

    def initialize(heading_details, back_button = nil, continuation = nil)
      raise ArgumentError, 'Use a HeadingDetails object' unless heading_details.is_a? HeadingDetail

      raise ArgumentError, 'Use a BackButtonDetail object' unless back_button.nil? || back_button.is_a?(BackButtonDetail)

      raise ArgumentError, 'Use a NavigationDetail object' unless continuation.nil? || continuation.is_a?(NavigationDetail)

      @heading_details = heading_details
      @back_button = back_button
      @navigation_details = continuation
    end
  end

  # Renders the top of the page including back-button, and the 3 elements of the main header
  # rubocop:disable Rails/OutputSafety
  def govuk_page_content(page_details, model_object = nil)
    raise ArgumentError, 'Use PageDescription object' unless page_details.is_a? PageDescription

    out = ''
    out = capture { govuk_page_error_summary(model_object) } unless model_object.nil?
    out << capture { govuk_back_button(page_details.back_button) }
    out << capture { govuk_page_header(page_details.heading_details) }

    out << capture do
      yield(page_details)
    end

    out.html_safe
  end

  def govuk_page_header(heading_details)
    content_tag(:h1, class: 'govuk-heading-xl') do
      if heading_details.caption?
        concat(content_tag(:span, class: 'govuk-caption-xl') do
          concat(heading_details.caption)
          concat("&nbsp;&mdash;&nbsp;#{heading_details.caption2}".html_safe) if heading_details.caption2.present?
        end).html_safe
        concat(heading_details.text)
      end
      concat(content_tag(:p, heading_details.subtitle, class: 'govuk-body-l')) if heading_details.subtitle.present?
    end
  end

  def govuk_back_button(back_button)
    link_to(back_button.text.nil? ? t('layouts.application.back') : back_button.text, back_button.url,
            aria: { label: back_button.label.nil? ? t('layouts.application.back_aria_label') : back_button.label },
            class: 'govuk-back-link govuk-!-margin-top-0 govuk-!-margin-bottom-6')
  end

  # rubocop:enable Rails/OutputSafety
  def govuk_continuation_buttons(page_description, form_builder)
    buttons = form_builder.submit(page_description.navigation_details.primary_text, class: 'govuk-button govuk-!-margin-right-4', data: { disable_with: false }, name: 'commit')
    buttons << form_builder.submit(page_description.navigation_details.secondary_text, class: 'govuk-button govuk-button__secondary', data: { disable_with: false }, name: 'commit')
    buttons << capture { tag.br }
    buttons << link_to(page_description.navigation_details.return_text, page_description.navigation_details.return_url, role: 'button', class: 'govuk-link')

    content_tag :div, class: 'govuk-!-margin-top-9' do
      buttons
    end
  end

  def govuk_page_error_summary(model_object)
    render partial: 'shared/error_summary', locals: { errors: model_object.errors, render_empty: true }
  end

  def govuk_start_individual_field(builder, attribute, &block)
    attribute_errors = builder&.object&.errors&.key?(attribute)
    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if attribute_errors

    options = { class: css_classes }
    options['aria-describedby'] = error_id(attribute) if attribute_errors

    content_tag :div, options do
      capture do
        concat(govuk_label(builder, builder.object, attribute))
        concat(display_potential_errors(builder.object, attribute, builder.object_name, nil, nil, nil))
        block.call(attribute) if block_given?
      end
    end
  end

  def govuk_grouped_fields(form, caption, *attributes)
    attributes_with_errors = attributes.flatten.select { |a| form.object.errors[a].any? }
    attributes_which_are_arrays = attributes.select { |a| form.object[a].is_a? Array }

    options = { class: 'govuk-fieldset' }
    options['aria-describedby'] = attributes_with_errors.map { |a| error_id(a) } if attributes_with_errors.any?

    content_tag :fieldset, options do
      capture do
        concat(list_errors_for_attributes(attributes_which_are_arrays)) if attributes_which_are_arrays.any?
        concat(content_tag(:legend,
                           content_tag(:h1, caption, class: 'govuk-fieldset__heading'),
                           class: 'govuk-fieldset__legend govuk-fieldset__legend--m'))

        attributes.flatten.each do |a|
          yield(form, a)
        end
      end
    end
  end

  def govuk_grouped_field(form, caption, attribute)
    attribute_has_errors = form.object.errors[attribute].any?
    attributes_is_an_array = form.object[attribute].is_a? Array

    options = { class: 'govuk-fieldset' }
    options['aria-describedby'] = error_id(attribute) if attribute_has_errors

    content_tag :fieldset, options do
      capture do
        concat(list_errors_for_attributes(attribute)) if attributes_is_an_array
        concat(content_tag(:legend,
                           content_tag(:h1, caption, class: 'govuk-fieldset__heading'),
                           class: 'govuk-fieldset__legend govuk-fieldset__legend--m'))

        yield(form, attribute)
      end
    end
  end

  INPUT_WIDTH = { tiny: 'govuk-input--width-2',
                  small: 'govuk-input--width-4',
                  medium: 'govuk-input--width-10',
                  large: 'govuk-input--width-20' }.freeze

  def govuk_text_input(builder, attribute, text_size, *option)
    css_classes = ['govuk-input']
    css_classes += ['govuk-input--error'] if builder.object.errors.key?(attribute)
    css_classes += [INPUT_WIDTH[text_size]]

    options = option.to_h.merge(class: css_classes)
    options.merge!('aria-describedby': error_id(attribute)) if builder.object.errors.key?(attribute)

    builder.text_field attribute, options
  end

  def govuk_button(builder, text, options = { submit: true })
    return builder.submit(text, class: 'govuk-button') if options.key?(:submit) ? options[:submit] : false

    builder.button(value: nil, options: { class: 'govuk-button' })
  end

  def govuk_label(builder, model, attribute)
    builder.label attribute, generate_label_text(model, attribute), class: 'govuk-label'
  end

  def generate_label_text(obj, attribute)
    if obj.class.respond_to?(:human_attribute_name)
      obj.class.human_attribute_name(attribute.to_s)
    else
      attribute.to_s.humanize
    end
  end

  def govuk_prevent_submission(_builder, value)
    content_tag :input, nil, name: 'preventsubmission', value: value, type: 'hidden'
  end
end
# rubocop:enable Metrics/ModuleLength
