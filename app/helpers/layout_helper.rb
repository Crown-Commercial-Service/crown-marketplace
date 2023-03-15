# rubocop:disable Metrics/ModuleLength
module LayoutHelper
  include ErrorsHelper

  # Renders the top of the page including back-button, and the 3 elements of the main header
  # rubocop:disable Rails/OutputSafety, Metrics/ParameterLists
  def govuk_page_content(page_details, model_object = nil, no_headings = false, no_back_button = false, no_error_block = false)
    raise ArgumentError, 'Use PageDescription object' unless page_details.is_a? FacilitiesManagement::PageDetail::PageDescription

    @no_back_button = no_back_button
    @no_error_block = no_error_block
    @no_headings    = no_headings

    out = ''
    out = capture { govuk_back_button(page_details.back_button) } unless no_back_button
    out << capture { govuk_page_error_summary(model_object) } unless model_object.nil? || !model_object.respond_to?(:errors) || no_error_block
    out << capture { govuk_page_header(page_details.heading_details) } unless no_headings

    out << capture do
      yield(page_details)
    end

    out.html_safe
  end
  # rubocop:enable Metrics/ParameterLists

  # rubocop:disable Metrics/AbcSize
  def govuk_page_header(heading_details)
    tag.h1(class: 'govuk-heading-xl', id: 'main_title') do
      if heading_details.caption3.present?
        concat(tag.span(class: 'govuk-caption-m govuk-!-margin-bottom-1') do
          concat(heading_details.caption3)
        end).html_safe
      end
      if heading_details.caption?
        concat(tag.span(class: 'govuk-caption-xl') do
          concat(heading_details.caption)
          concat(" — #{heading_details.caption2}") if heading_details.caption2.present?
        end).html_safe
      end
      concat(heading_details.text)
      concat(tag.p(heading_details.subtitle, class: 'govuk-body-l')) if heading_details.subtitle.present?
    end
  end

  # rubocop:enable Metrics/AbcSize

  def govuk_back_button(back_button)
    link_to(back_button.text.nil? ? t('layouts.application.back') : back_button.text, back_button.url,
            aria: { label: back_button.label.nil? ? t('layouts.application.back_aria_label') : back_button.label },
            title: back_button.label.nil? ? t('layouts.application.back_aria_label') : back_button.label,
            class: 'govuk-back-link govuk-!-margin-top-0 govuk-!-margin-bottom-6')
  end

  # rubocop:enable Rails/OutputSafety

  # rubocop:disable Metrics/ParameterLists
  def govuk_continuation_buttons(page_description, form_builder, secondary_button = true, return_link = true, primary_button = true, red_secondary_button = false, primary_btn_as_link = false, secondary_btn_as_link = false)
    buttons = ActiveSupport::SafeBuffer.new

    buttons << govuk_first_button(page_description, form_builder, red_secondary_button, primary_btn_as_link) if primary_button
    buttons << govuk_second_button(page_description, form_builder, red_secondary_button, secondary_btn_as_link) if secondary_button

    if (secondary_button || primary_button) && return_link
      buttons << tag.br
      buttons << link_to(page_description.navigation_details.return_text, page_description.navigation_details.return_url, class: 'govuk-link govuk-!-font-size-19', aria: { label: page_description.navigation_details.return_text })
    end

    tag.div(class: 'govuk-!-margin-top-5') do
      buttons
    end
  end
  # rubocop:enable Metrics/ParameterLists

  def govuk_first_button(page_description, form_builder, red_secondary_button, primary_btn_as_link)
    if primary_btn_as_link
      link_to(page_description.navigation_details.primary_text, page_description.navigation_details.primary_url, class: "govuk-!-margin-right-4 govuk-button #{red_secondary_button ? 'govuk-button--warning' : 'govuk-button--secondary'}", role: 'button') if page_description.navigation_details.primary_url.present?
    else
      form_builder.submit(page_description.navigation_details.primary_text, class: 'govuk-button govuk-!-margin-right-4', name: [page_description.navigation_details.primary_name, 'commit'].find(&:present?), aria: { label: page_description.navigation_details.primary_text })
    end
  end

  def govuk_second_button(page_description, form_builder, red_secondary_button, secondary_btn_as_link)
    if secondary_btn_as_link
      link_to(page_description.navigation_details.secondary_text, page_description.navigation_details.secondary_url, class: "govuk-button #{red_secondary_button ? 'govuk-button--warning' : 'govuk-button--secondary'}", role: 'button')
    else
      form_builder.submit(page_description.navigation_details.secondary_text, class: "govuk-button #{red_secondary_button ? 'govuk-button--warning' : 'govuk-button--secondary'}", name: [page_description.navigation_details.secondary_name, 'commit'].find(&:present?), aria: { label: page_description.navigation_details.secondary_text })
    end
  end

  def govuk_page_error_summary(model_object)
    render partial: 'shared/error_summary', locals: { errors: model_object.errors, render_empty: true }
  end

  # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity,Metrics/ParameterLists
  def govuk_start_individual_field(builder, attribute, label_text = {}, require_label = true, show_errors = true, options = {}, hide_error_text = false, &block)
    attribute_errors = builder&.object&.errors&.key?(attribute)
    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if attribute_errors && show_errors

    options.merge!(class: css_classes.join(' '))
    options['aria-describedby'] = error_id(attribute) if attribute_errors
    options.merge!(property_name: attribute).symbolize_keys!

    tag.div(**options) do
      capture do
        concat(govuk_label_old(builder, builder.object, attribute, label_text)) if require_label
        concat(display_error(builder.object, attribute)) if show_errors && !hide_error_text
        block.call(attribute) if block_given?
      end
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity,Metrics/ParameterLists

  # rubocop:disable Metrics/AbcSize
  def govuk_grouped_fields(form, caption, *attributes)
    attributes_with_errors      = attributes.flatten.select { |a| form.object.errors[a].any? }
    attributes_which_are_arrays = attributes.select { |a| form.object[a].is_a? Array }

    options                     = { class: 'govuk-fieldset' }
    options['aria-describedby'] = attributes_with_errors.map { |a| error_id(a) } if attributes_with_errors.any?

    tag.fieldset(options) do
      capture do
        concat(list_errors_for_attributes(attributes_which_are_arrays)) if attributes_which_are_arrays.any?
        concat(tag.legend(caption, class: 'govuk-fieldset__legend govuk-fieldset__legend--m'))

        attributes.flatten.each do |a|
          yield(form, a)
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def contained_content(caption, &block)
    tag.div(class: 'govuk-!-margin-bottom-3') do
      concat(tag.h2(caption, class: 'govuk-heading-m'))
      block.call
    end
  end

  def govuk_grouped_field(form, caption, attribute, header_text = '', &)
    attribute_has_errors = form.object.errors[attribute].any?

    options         = {}
    options[:aria]  = { describedby: error_id(attribute) } if attribute_has_errors
    css_classes     = ['govuk-fieldset']
    options[:class] = css_classes

    if attribute_has_errors
      tag.div(fieldset_structure(form, caption, options, header_text, attribute, &), class: 'govuk-form-group govuk-form-group--error')
    else
      fieldset_structure(form, caption, options, header_text, attribute, &)
    end
  end

  # rubocop:disable Metrics/AbcSize
  def fieldset_structure(form, caption, options, header_text, *attributes, &block)
    tag.fieldset(**options) do
      capture do
        concat(tag.legend(caption, class: 'govuk-fieldset__legend govuk-fieldset__legend--m')) unless caption.nil?
        concat(tag.p(header_text, class: 'govuk-caption-m')) if header_text.present?
        attributes.flatten.each do |attr|
          concat(list_errors_for_attributes(attr)) if form.object[attr].is_a? Array
          concat(display_error(form.object, attr, false)) unless form.object[attr].is_a? Array
        end
        block.call(form, attributes.flatten)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def govuk_button(builder, text, options = { submit: true, class: '' })
    css_classes = ['govuk-button']
    css_classes << options[:class]
    css_classes += text == ['aria-label']
    css_classes += ['govuk-button--secondary'] if options[:button] == :secondary
    css_classes += ['govuk-button--warning'] if options[:button] == :warning

    return builder.submit(text, class: css_classes) if options.key?(:submit) ? options[:submit] : false

    builder.button(value: nil, class: css_classes)
  end

  def govuk_label_old(builder, model, attribute, label_text = {})
    builder.label attribute, generate_label_text(model, attribute, label_text), class: 'govuk-label govuk-!-margin-bottom-1'
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
    tag.input(nil, name: 'preventsubmission', value: value, type: 'hidden')
  end

  def form_group_with_error(model, attribute)
    css_classes = ['govuk-form-group']
    any_errors = model.errors.include? attribute
    css_classes += ['govuk-form-group--error'] if any_errors

    tag.div(class: css_classes, id: "#{attribute}-form-group") do
      yield(display_error(model, attribute), any_errors)
    end
  end

  def hint_details(question, hint)
    capture do
      concat(tag.legend(question, class: 'govuk-heading-m govuk-!-margin-bottom-0 govuk-!-padding-left-0'))
      concat(tag.span(hint, class: 'govuk-caption-m govuk-!-margin-bottom-0'))
    end
  end

  def label_details(form, attribute, label_text, hint)
    capture do
      concat(form.label(attribute, label_text, class: 'govuk-heading-m govuk-!-margin-bottom-0 govuk-!-padding-left-0'))
      concat(tag.span(hint, class: 'govuk-caption-m govuk-!-margin-bottom-0'))
    end
  end

  def numbered_list_helper(heading, &)
    capture do
      concat(tag.h2(heading, class: 'govuk-heading-m govuk-!-font-weight-bold govuk-!-margin-bottom-2'))
      concat(tag.div(class: 'govuk-body govuk-!-padding-left-5', &))
    end
  end

  def ccs_account_panel_row(**options, &)
    class_list = ['govuk-grid-row govuk-!-margin-bottom-6 fm-buyer-account-panel__container']
    class_list << options.delete(:class)

    tag.div(class: class_list, **options, &)
  end

  def ccs_account_panel(title, title_url, **options, &)
    class_list = ['govuk-grid-column-one-third fm-buyer-account-panel']
    class_list << options.delete(:class)

    tag.div(class: class_list, **options) do
      capture do
        concat(tag.p do
          link_to(title, title_url, class: 'ccs-font-weight-semi-bold fm-buyer-account-panel__title_no_link govuk-!-margin-bottom-2 govuk-link--no-visited-state')
        end)
        concat(tag.p(class: 'govuk-!-top-padding-4', &))
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
