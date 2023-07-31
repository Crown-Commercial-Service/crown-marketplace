# rubocop:disable Metrics/ModuleLength
module ApplicationHelper
  include LayoutHelper
  include GovUKHelper
  include HeaderNavigationLinksHelper

  def feedback_email_link
    link_to(t('common.feedback'), Marketplace.fm_survey_link, target: '_blank', rel: 'noopener', class: 'govuk-link')
  end

  def dfe_account_request_url
    'https://ccsheretohelp.uk/contact/?type=ST18/19'
  end

  def support_telephone_number
    Marketplace.support_telephone_number
  end

  def govuk_email_link(email_address, aria_label, css_class: 'govuk-link')
    mail_to(email_address, t('layouts.application.feedback'), class: css_class, 'aria-label': aria_label)
  end

  # rubocop:disable Metrics/ParameterLists
  def govuk_form_field(model_object, attribute, form_object_name, label_text, readable_property_name, top_level_data_options)
    css_classes = %w[govuk-!-margin-top-3]
    form_group_css = ['govuk-form-group']
    form_group_css += ['govuk-form-group--error'] if model_object.errors[attribute].any?
    label_for_id = form_object_name
    id_for_label = "#{form_object_name}_#{attribute}-info"
    label_for_id += "_#{attribute}" if form_object_name.exclude?(attribute.to_s)

    tag.div(class: css_classes, data: { propertyname: readable_property_name }) do
      tag.div(class: form_group_css, data: top_level_data_options) do
        concat display_label(attribute, label_text, label_for_id, id_for_label) if label_text.present?
        concat display_potential_errors(model_object, attribute, "#{form_object_name}_#{attribute}")
        yield
      end
    end
  end
  # rubocop:enable Metrics/ParameterLists

  def display_label(_attribute, text, form_object_name, _id_for_label)
    tag.label(text, class: 'govuk-label', for: form_object_name)
  end

  def govuk_form_group_with_optional_error(journey, *attributes, &)
    attributes_with_errors = attributes.select { |a| journey.errors[a].any? }

    css_classes = ['govuk-form-group']
    css_classes += ['govuk-form-group--error'] if attributes_with_errors.any?

    tag.div(class: css_classes, &)
  end

  def govuk_fieldset_with_optional_error(journey, *attributes, &)
    attributes_with_errors = attributes.select { |a| journey.errors[a].any? }

    options = { class: 'govuk-fieldset' }
    options['aria-describedby'] = attributes_with_errors.map { |a| error_id(a) } if attributes_with_errors.any?

    tag.fieldset(**options, &)
  end

  def list_potential_errors(model_object, attribute, form_object_name, error_lookup = nil, error_position = nil)
    collection = validation_messages(model_object.class.name.underscore.downcase.to_sym, attribute)

    collection.each do |key, val|
      concat(govuk_validation_error({ model_object: model_object, attribute: attribute, error_type: key, text: val, form_object_name: form_object_name }, error_lookup, error_position))
    end
  end

  def property_name(section_name, attributes)
    return "#{section_name}_#{attributes.is_a?(Array) ? attributes.last : attributes}" unless section_name.nil?

    (attributes.is_a?(Array) ? attributes.last : attributes).to_s
  end

  def display_potential_errors(model_object, attributes, form_object_name, section_name = nil)
    collection = validation_messages(model_object.class.name.underscore.downcase.to_sym, attributes)
    return if collection.empty?

    tag.div(class: 'error-collection potenital-error', property_name: property_name(section_name, attributes)) do
      multiple_validation_errors(model_object, attributes, form_object_name, collection)
    end
  end

  def model_attribute_has_error(model_object, *attributes)
    result = false
    attributes.any? { |a| result |= model_object.errors[a]&.any? }
  end

  def model_has_error?(model_object, error_type, *attributes)
    attributes.any? { |a| model_object&.errors&.details&.dig(a, 0)&.fetch(:error, nil) == error_type }
  end

  def display_errors(journey, *attributes)
    safe_join(attributes.map { |a| display_error(journey, a) })
  end

  def display_error(journey, attribute, margin = true, id_prefix = '')
    error = journey.errors[attribute].first
    return if error.blank?

    tag.span(id: "#{id_prefix}#{error_id(attribute)}", class: "govuk-error-message #{'govuk-!-margin-top-3' if margin}") do
      error.to_s
    end
  end

  ERROR_TYPES = {
    too_long: 'maxlength',
    too_short: 'minlength',
    blank: 'required',
    inclusion: 'required',
    after: 'max',
    greater_than: 'min',
    greater_than_or_equal_to: 'min',
    before: 'min',
    less_than: 'max',
    less_than_or_equal_to: 'max',
    not_a_date: 'pattern',
    not_a_number: 'number',
    not_an_integer: 'number'
  }.freeze

  def get_client_side_error_type_from_errors(errors, attribute)
    return ERROR_TYPES[errors.details[attribute].first[:error]] if ERROR_TYPES.key?(errors.details[attribute].try(:first)[:error])

    errors.details[attribute].first[:error].to_sym unless ERROR_TYPES.key?(errors.details[attribute].first[:error])
  end

  def get_client_side_error_type_from_model(model, attribute)
    return ERROR_TYPES[model.errors.details[attribute].first[:error]] if ERROR_TYPES.key?(model.errors.details[attribute].first[:error])

    model.errors.details[attribute].first[:error].to_sym unless ERROR_TYPES.key?(model.errors.details[attribute].first[:error])
  end

  def display_error_label(model, attribute, label_text, target)
    error = model.errors[attribute].first
    return if error.blank?

    tag.label(data: { validation: get_client_side_error_type_from_model(model, attribute).to_s }, for: target, id: error_id(attribute), class: 'govuk-error-message') do
      "#{label_text} #{error}"
    end
  end

  def display_error_no_attr(object, attribute)
    error = object.errors[attribute].first
    return if error.blank?

    tag.span(id: error_id(attribute.to_s), class: 'govuk-error-message govuk-!-margin-top-3') do
      error.to_s
    end
  end

  def display_error_nested_models(object, attribute)
    error = object.errors[attribute].first
    return if error.blank?

    tag.span(id: error_id(object.id), class: 'govuk-error-message govuk-!-margin-top-3') do
      error.to_s
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
    title = %i[page_title_prefix page_title page_section].map do |title_bit|
      content_for(title_bit)
    end
    title += [t('layouts.application.title')]
    title.compact_blank.map(&:strip).join(': ')
  end

  def add_optional_error_prefix_to_page_title(errors)
    content_for(:page_title_prefix) { t('layouts.application.error_prefix') } unless errors.empty?
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

  def format_date(date_object)
    date_object&.in_time_zone('London')&.strftime '%e %B %Y'
  end

  def format_date_time(date_object)
    date_object&.in_time_zone('London')&.strftime '%e %B %Y, %l:%M%P'
  end

  def format_date_time_day(date_object)
    date_object&.in_time_zone('London')&.strftime '%e %B %Y, %l:%M%P'
  end

  def format_money(cost, precision = 2)
    number_to_currency(cost, precision: precision, unit: '£')
  end

  def govuk_tag(status)
    extra_classes = {
      cannot_start: 'govuk-tag--grey',
      incomplete: 'govuk-tag--red',
      in_progress: 'govuk-tag--blue',
      not_started: 'govuk-tag--grey',
      not_required: 'govuk-tag--grey'
    }

    tag.strong(I18n.t(status, scope: 'shared.tags'), class: ['govuk-tag'] << extra_classes[status])
  end

  def govuk_tag_with_text(colour, text)
    extra_classes = {
      grey: 'govuk-tag--grey',
      blue: 'govuk-tag',
      red: 'govuk-tag--red'
    }

    tag.strong(text, class: ['govuk-tag'] << extra_classes[colour])
  end

  def da_eligible?(code)
    FacilitiesManagement::RM3830::Rate.where.not(framework: nil).map(&:code).include? code
  end

  def service_specification_document(framework)
    link_to_public_file_for_download(t("facilities_management.#{framework}.documents.service_specification_document.name"), :pdf, t("facilities_management.#{framework}.documents.service_specification_document.text"), true, alt: t('facilities_management.select_services.servicespec_link_alttext'))
  end

  def govuk_radio_driver
    tag.div(t('common.radio_driver'), class: 'govuk-radios__divider')
  end

  def warning_text(text)
    tag.div(class: 'govuk-warning-text') do
      concat(tag.span('!', class: 'govuk-warning-text__icon', aria: { hidden: true }))
      concat(
        tag.strong(class: 'govuk-warning-text__text') do
          concat(tag.span('Warning', class: 'govuk-warning-text__assistive'))
          concat(text)
        end
      )
    end
  end

  def find_address_helper(object, organisaiton_prefix)
    FacilitiesManagement::FindAddressHelper.new(object, organisaiton_prefix)
  end

  def hidden_class(visible)
    'govuk-visually-hidden' unless visible
  end

  def input_visible?(visible)
    visible ? 0 : -1
  end

  def search_box(placeholder_text, column = 0)
    text_field_tag 'fm-table-filter-input', nil, class: 'govuk-input', placeholder: placeholder_text, data: { column: }
  end

  def link_to_public_file_for_download(filename, file_type, text, show_doc_image, **)
    link_to_file_for_download("/#{filename}?format=#{file_type}", file_type, text, show_doc_image, **)
  end

  def link_to_generated_file_for_download(filename, file_type, text, show_doc_image, **)
    link_to_file_for_download("#{filename}?format=#{file_type}", file_type, text, show_doc_image, **)
  end

  def link_to_file_for_download(file_link, file_type, text, show_doc_image, **)
    link_to(file_link, class: ('supplier-record__file-download' if show_doc_image).to_s, type: t("common.type_#{file_type}"), download: '', **) do
      capture do
        concat(text)
        concat(tag.span(t("common.#{file_type}_html"), class: 'govuk-visually-hidden')) if show_doc_image
      end
    end
  end

  def cookie_policy_path
    "#{service_path_base}/cookie-policy"
  end

  def cookie_settings_path
    "#{service_path_base}/cookie-settings"
  end

  def accessibility_statement_path
    "#{service_path_base}/accessibility-statement"
  end

  def contact_link(link_text)
    link_to(link_text, Marketplace.support_form_link, target: :blank)
  end

  def accordion_region_items(region_codes, with_overseas: false)
    nuts1_regions = Nuts1Region.send(with_overseas ? :all_with_overseas : :all).to_h { |region| [region.code, { name: region.name, items: [] }] }

    FacilitiesManagement::Region.all.each do |region|
      region_group_code = region.code[..2]

      next unless nuts1_regions[region_group_code]

      nuts1_regions[region.code[..2]][:items] << {
        code: region.code,
        value: region.code,
        name: "#{region.name.gsub(160.chr('UTF-8'), ' ')} (#{region.code})",
        selected: region_codes.include?(region.code)
      }
    end

    nuts1_regions
  end

  def rm3830_accordion_service_items(service_codes)
    services = FacilitiesManagement::RM3830::StaticData.services
    work_packages = FacilitiesManagement::RM3830::StaticData.work_packages

    services.map do |service|
      [
        service['code'],
        {
          name: service['name'],
          items: work_packages.select { |work_package| work_package['work_package_code'] == service['code'] }.map do |work_package|
            {
              code: work_package['code'].tr('.', '-'),
              value: work_package['code'],
              name: work_package['name'],
              selected: service_codes&.include?(work_package['code']),
              description: work_package['description']
            }
          end
        }
      ]
    end
  end

  def rm6232_accordion_service_items(service_codes)
    FacilitiesManagement::RM6232::WorkPackage.selectable.map do |work_package|
      [
        work_package.code,
        {
          name: work_package.name,
          items: work_package.selectable_services.map do |service|
            {
              code: service.code.tr('.', '-'),
              value: service.code,
              name: service.name,
              selected: service_codes&.include?(service.code),
              description: service.description
            }
          end
        }
      ]
    end
  end

  def can_show_new_framework_banner?
    Marketplace.rm6232_live? || params[:show_new_framework_banner].present?
  end

  # rubocop:disable Metrics/ParameterLists
  def link_to_add_row(name, number_of_items, form, association, partial_prefix, **args)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render("#{partial_prefix}/#{association.to_s.singularize}", ff: builder)
    end
    link_to(name.gsub('<number_of_items>', number_of_items.to_s), '#', class: args[:class], data: { id: id, fields: fields.gsub('\n', ''), 'button-text': name })
  end
  # rubocop:enable Metrics/ParameterLists

  def cookie_preferences_settings
    @cookie_preferences_settings ||= begin
      current_cookie_preferences = JSON.parse(cookies[Marketplace.cookie_settings_name] || '{}')

      !current_cookie_preferences.is_a?(Hash) || current_cookie_preferences.empty? ? Marketplace.default_cookie_options : current_cookie_preferences
    end
  end
end
# rubocop:enable Metrics/ModuleLength
