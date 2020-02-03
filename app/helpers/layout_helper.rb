# rubocop:disable Metrics/ModuleLength
module LayoutHelper
  include ErrorsHelper

  # Module to render page elements
  # field-sets and input groups
  # errors

  # Value Objects (Classes) to structure data for parameters to helper methods
  class NavigationDetail
    attr_accessor(:primary_text, :primary_name, :return_url, :return_text, :secondary_url, :secondary_text, :secondary_name)

    # rubocop:disable Metrics/ParameterLists
    def initialize(primary_text, return_url, return_text, secondary_url, secondary_text, primary_name = '', secondary_name = '')
      @primary_text = primary_text
      @primary_name = primary_name
      @return_url = return_url
      @return_text = return_text
      @secondary_url = secondary_url
      @secondary_text = secondary_text
      @secondary_name = secondary_name
    end
    # rubocop:enable Metrics/ParameterLists
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
    attr_accessor(:no_back_button, :no_error_block, :no_headings)

    def initialize(heading_details, back_button = nil, continuation = nil)
      raise ArgumentError, 'Use a HeadingDetails object' unless heading_details.is_a? HeadingDetail

      raise ArgumentError, 'Use a BackButtonDetail object' unless back_button.nil? || back_button.is_a?(BackButtonDetail)

      raise ArgumentError, 'Use a NavigationDetail object' unless continuation.nil? || continuation.is_a?(NavigationDetail)

      @no_back_button = @no_error_block = @no_headings = false
      @heading_details = heading_details
      @back_button = back_button
      @navigation_details = continuation
    end
  end

  # Renders the top of the page including back-button, and the 3 elements of the main header
  # rubocop:disable Rails/OutputSafety
  def govuk_page_content(page_details, model_object = nil, no_headings = false, no_back_button = false, no_error_block = false)
    raise ArgumentError, 'Use PageDescription object' unless page_details.is_a? PageDescription

    @no_back_button = no_back_button
    @no_error_block = no_error_block
    @no_headings = no_headings

    out = ''
    out = capture { govuk_back_button(page_details.back_button) } unless no_back_button
    out << capture { govuk_page_error_summary(model_object) } unless model_object.nil? || no_error_block
    out << capture { govuk_page_header(page_details.heading_details) } unless no_headings

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
      end
      concat(heading_details.text)
      concat(content_tag(:p, heading_details.subtitle, class: 'govuk-body-l')) if heading_details.subtitle.present?
    end
  end

  def govuk_back_button(back_button)
    link_to(back_button.text.nil? ? t('layouts.application.back') : back_button.text, back_button.url,
            aria: { label: back_button.label.nil? ? t('layouts.application.back_aria_label') : back_button.label },
            class: 'govuk-back-link govuk-!-margin-top-0 govuk-!-margin-bottom-6')
  end
  # rubocop:enable Rails/OutputSafety

  # rubocop:disable Metrics/AbcSize
  def govuk_continuation_buttons(page_description, form_builder, secondary_button = true, return_link = true, primary_button = true)
    buttons = form_builder.submit(page_description.navigation_details.primary_text, class: 'govuk-button govuk-!-margin-right-4', data: { disable_with: false }, name: [page_description.navigation_details.primary_name, 'commit'].find(&:present?)) if primary_button
    buttons = form_builder.submit(page_description.navigation_details.secondary_text, class: 'govuk-button govuk-button--secondary', data: { disable_with: false }, name: [page_description.navigation_details.secondary_name, 'commit'].find(&:present?)) unless primary_button
    buttons << form_builder.submit(page_description.navigation_details.secondary_text, class: 'govuk-button govuk-button--secondary', data: { disable_with: false }, name: [page_description.navigation_details.secondary_name, 'commit'].find(&:present?)) if secondary_button
    buttons << capture { tag.br }
    buttons << link_to(page_description.navigation_details.return_text, page_description.navigation_details.return_url, role: 'button', class: 'govuk-link') if return_link

    content_tag :div, class: 'govuk-!-margin-top-5' do
      buttons
    end
  end
  # rubocop:enable Metrics/AbcSize

  def govuk_page_error_summary(model_object)
    render partial: 'shared/error_summary', locals: { errors: model_object.errors, render_empty: true }
  end

  # rubocop:disable Metrics/CyclomaticComplexity,Metrics/ParameterLists
  def govuk_start_individual_field(builder, attribute, label_text = {}, require_label = true, show_errors = true, &block)
    attribute_errors = builder&.object&.errors&.key?(attribute)
    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if attribute_errors && show_errors

    options = { class: css_classes }
    options['aria-describedby'] = error_id(attribute) if attribute_errors

    content_tag :div, options do
      capture do
        concat(govuk_label(builder, builder.object, attribute, label_text)) if require_label
        concat(display_potential_errors(builder.object, attribute, builder.object_name, nil, nil, nil)) if show_errors
        block.call(attribute) if block_given?
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity,Metrics/ParameterLists

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

  def govuk_grouped_field(form, caption, attribute, &block)
    attribute_has_errors = form.object.errors[attribute].any?
    attribute_is_an_array = form.object[attribute].is_a? Array

    options = {}
    options['aria-describedby'] = error_id(attribute) if attribute_has_errors
    css_classes = ['govuk-fieldset']
    options['class'] = css_classes

    if attribute_has_errors
      content_tag :div, fieldset_structure(form, caption, attribute, attribute_is_an_array, options, &block),
                  class: 'govuk-form-group govuk-form-group--error'
    else
      fieldset_structure(form, caption, attribute, attribute_is_an_array, options, &block)
    end
  end

  # rubocop:disable Metrics/ParameterLists
  def fieldset_structure(form, caption, attribute, attribute_is_an_array, options, &block)
    content_tag :fieldset, options do
      capture do
        concat(content_tag(:legend,
                           content_tag(:h1, caption, class: 'govuk-fieldset__heading'),
                           class: 'govuk-fieldset__legend govuk-fieldset__legend--m'))
        concat(list_errors_for_attributes(attribute)) if attribute_is_an_array
        concat(display_error(form.object, attribute)) unless attribute_is_an_array
        block.call(form, attribute)
      end
    end
  end
  # rubocop:enable Metrics/ParameterLists

  INPUT_WIDTH = { tiny: 'govuk-input--width-2',
                  small: 'govuk-input--width-4',
                  medium: 'govuk-input--width-10',
                  large: 'govuk-input--width-20',
                  one_half: 'govuk-!-width-one-half',
                  two_thirds: 'govuk-!-width-two-thirds',
                  one_quarter: 'govuk-!-width-one-quarter' }.freeze

  def govuk_text_input(builder, attribute, text_size, *option)
    css_classes = ['govuk-input']
    css_classes += ['govuk-input--error'] if builder.object.errors.key?(attribute)
    css_classes += [INPUT_WIDTH[text_size]]

    options = option.to_h.merge(class: css_classes)
    options.merge!('aria-describedby': error_id(attribute)) if builder.object.errors.key?(attribute)

    builder.text_field attribute, options
  end

  def govuk_text_area_input(builder, attribute, char_count = false, *option)
    css_classes = ['govuk-textarea']
    css_classes << option.to_h[:class] if option.to_h.key? :class
    css_classes += ['govuk-input--error'] if builder.object.errors.key?(attribute)
    css_classes += ['js-character-count'] if char_count

    options = option.to_h.merge(class: css_classes)
    options.merge!('aria-describedby': error_id(attribute)) if builder.object.errors.key?(attribute)

    builder.text_area attribute, options
  end

  def govuk_button(builder, text, options = { submit: true, class: '' })
    css_classes = ['govuk-button']
    css_classes << options[:class]
    css_classes += ['govuk-button--secondary'] if options[:button] == :secondary
    css_classes += ['govuk-button--warning'] if options[:button] == :warning

    return builder.submit(text, class: css_classes) if options.key?(:submit) ? options[:submit] : false

    builder.button(value: nil, class: css_classes)
  end

  def govuk_label(builder, model, attribute, label_text = {})
    builder.label attribute, generate_label_text(model, attribute, label_text), class: 'govuk-label govuk-!-margin-bottom-1'
  end

  def govuk_details(summary_text, &block)
    content_tag :details, class: 'govuk-details', data: { module: 'govuk-details' } do
      capture do
        concat(content_tag(:summary, content_tag(:span, summary_text, class: 'govuk-details__summary-text'), class: 'govuk-details__summary'))
        concat(content_tag(:div, class: 'govuk-details__text', &block))
      end
    end
  end

  def generate_label_text(obj, attribute, label_text = {})
    if label_text.key?(attribute)
      label_text[attribute]
    elsif obj.class.respond_to?(:human_attribute_name)
      obj.class.human_attribute_name(attribute.to_s)
    else
      attribute.to_s.humanize
    end
  end

  def govuk_prevent_submission(_builder, value)
    content_tag :input, nil, name: 'preventsubmission', value: value, type: 'hidden'
  end

  def navigation_link_supplier_and_buyer
    html = []
    html << content_tag(:li, class: 'govuk-header__navigation-item') do
      if current_user&.has_role?(:supplier)
        link_to 'My dashboard', facilities_management_beta_supplier_supplier_account_dashboard_path, class: 'govuk-header__link' if user_signed_in?
      elsif current_user&.has_role?(:buyer)
        link_to 'My Account', facilities_management_beta_path, class: 'govuk-header__link' if user_signed_in?
      end
    end
    html << content_tag(:li, class: 'govuk-header__navigation-item') do
      link_to 'Sign out', service_destroy_user_session_path, method: :delete, class: 'govuk-header__link ccs-header__signout'
    end
    safe_join(html)
  end

  def not_permitted_page_header_link
    if current_user&.has_role?(:supplier)
      render 'facilities_management/beta/supplier/link_to_start_page'
    elsif current_user&.has_role?(:buyer)
      render 'facilities_management/beta/link_to_start_page'
    end
  end
end
# rubocop:enable Metrics/ModuleLength
