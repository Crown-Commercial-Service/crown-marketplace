# rubocop:disable Metrics/ModuleLength
module ApplicationHelper
  include LayoutHelper

  ADMIN_CONTROLLERS = ['supply_teachers/admin', 'management_consultancy/admin', 'legal_services/admin'].freeze
  PLATFORM_LANDINGPAGES = ['', 'legal_services/home', 'supply_teachers/home', 'management_consultancy/home', 'apprenticeships/home'].freeze
  FACILITIES_MANAGEMENT_LANDINGPAGES = ['facilities_management/home'].freeze

  def miles_to_metres(miles)
    DistanceConverter.miles_to_metres(miles)
  end

  def metres_to_miles(metres)
    DistanceConverter.metres_to_miles(metres)
  end

  def feedback_email_link
    return link_to(t('common.feedback'), Marketplace.supply_teachers_survey_link, target: '_blank', rel: 'noopener', class: 'govuk-link') if controller.class.try(:parent_name) == 'SupplyTeachers'

    return link_to(t('common.feedback'), 'https://www.smartsurvey.co.uk/s/BGBL4/', target: '_blank', rel: 'noopener', class: 'govuk-link') if controller.class.try(:parent_name) == 'LegalServices'

    return link_to(t('common.feedback'), 'https://www.smartsurvey.co.uk/s/MIIJB/', target: '_blank', rel: 'noopener', class: 'govuk-link') if controller.class.try(:parent_name) == 'ManagementConsultancy'

    govuk_email_link(Marketplace.feedback_email_address, t('layouts.application.feedback_aria_label'), css_class: 'govuk-link ga-feedback-mailto')
  end

  def support_email_link(label)
    govuk_email_link(Marketplace.support_email_address, label, css_class: 'govuk-link ga-support-mailto')
  end

  def footer_email_link(label)
    mail_to(Marketplace.support_email_address, Marketplace.support_email_address, class: 'govuk-link ga-support-mailto', 'aria-label': label)
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

    content_tag :div, class: css_classes, data: { propertyname: readable_property_name } do
      content_tag :div, class: form_group_css, data: top_level_data_options do
        concat display_label(attribute, label_text, label_for_id, id_for_label) if label_text.present?
        concat display_potential_errors(model_object, attribute, "#{form_object_name}_#{attribute}")
        yield
      end
    end
  end
  # rubocop:enable Metrics/ParameterLists

  def display_label(_attribute, text, form_object_name, _id_for_label)
    content_tag :label, text, class: 'govuk-label', for: form_object_name
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

  # rubocop:disable Metrics/ParameterLists
  def display_potential_errors(model_object, attributes, form_object_name, error_lookup = nil, error_position = nil, section_name = nil)
    collection = validation_messages(model_object.class.name.underscore.downcase.to_sym, attributes)

    content_tag :div, class: 'error-collection', property_name: property_name(section_name, attributes) do
      collection.each do |key, val|
        concat(govuk_validation_error({ model_object: model_object, attribute: attributes.is_a?(Array) ? attributes.last : attributes, error_type: key, text: val, form_object_name: form_object_name }, error_lookup, error_position))
      end
    end
  end
  # rubocop:enable Metrics/ParameterLists

  def model_attribute_has_error(model_object, *attributes)
    result = false
    attributes.any? { |a| result |= model_object.errors[a]&.any? }
  end

  def model_has_error?(model_object, error_type, *attributes)
    result = false
    attributes.each { |a| result |= (model_object&.errors&.details&.dig(a, 0)&.fetch(:error, nil)) == error_type }
    result
  end

  def display_errors(journey, *attributes)
    safe_join(attributes.map { |a| display_error(journey, a) })
  end

  def display_error(journey, attribute, margin = true)
    error = journey.errors[attribute].first
    return if error.blank?

    content_tag :span, id: error_id(attribute), class: "govuk-error-message #{'govuk-!-margin-top-3' if margin}" do
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

    content_tag :label, data: { validation: get_client_side_error_type_from_model(model, attribute).to_s }, for: target, id: error_id(attribute), class: 'govuk-error-message' do
      "#{label_text} #{error}"
    end
  end

  def display_error_no_attr(object, attribute)
    error = object.errors[attribute].first
    return if error.blank?

    content_tag :span, id: error_id(attribute.to_s), class: 'govuk-error-message govuk-!-margin-top-3' do
      error.to_s
    end
  end

  def display_error_nested_models(object, attribute)
    error = object.errors[attribute].first
    return if error.blank?

    content_tag :span, id: error_id(object.id), class: 'govuk-error-message govuk-!-margin-top-3' do
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
    title.reject(&:blank?).map(&:strip).join(': ')
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

  def service_header_banner
    if params[:service]
      render partial: "#{params[:service]}/header-banner"
    else
      service_name = controller.class.parent_name&.underscore
      if service_name&.include? 'admin'
        render partial: 'layouts/admin/header-banner'
      elsif service_name && lookup_context.template_exists?("#{service_name}/_header-banner")
        render partial: "#{service_name}/header-banner"
      else
        render partial: 'layouts/header-banner'
      end
    end
  end

  def landing_or_admin_page
    (PLATFORM_LANDINGPAGES.include?(controller.class.controller_path) && controller.action_name == 'index') || controller.action_name == 'landing_page' || ADMIN_CONTROLLERS.include?(controller.class.parent_name.try(:underscore))
  end

  def fm_landing_page
    (FACILITIES_MANAGEMENT_LANDINGPAGES.include?(controller.class.controller_path) && controller.action_name == 'index')
  end

  def fm_buyer_landing_page
    request.path_info.include? 'buyer-account'
  end

  def fm_supplier_landing_page
    request.path_info.include? 'supplier'
  end

  def fm_supplier_login_page
    controller.controller_name == 'sessions' && controller.action_name == 'new'
  end

  def not_permitted_page
    controller.action_name == 'not_permitted'
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

  def link_to_add_row(name, form, association, **args)
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render("facilities_management/procurements/edit/#{association.to_s.singularize}", ff: builder)
    end
    link_to(name, '#', class: 'add-pension-fields ' + args[:class], data: { id: id, fields: fields.gsub('\n', '') })
  end

  def determine_rate_card_service_price_text(service_type, work_pckg_code, supplier_data_ratecard_prices, supplier_data_ratecard_discounts)
    if service_type == 'Direct Award Discount (%)'
      supplier_data_ratecard_discounts.values[0][work_pckg_code].nil? ? '' : supplier_data_ratecard_discounts.values[0][work_pckg_code]['Disc %']
    else
      supplier_data_ratecard_prices.values[0][work_pckg_code].nil? ? '' : supplier_data_ratecard_prices.values[0][work_pckg_code][service_type.remove(' (%)').remove(' (£)')]
    end
  end
end
# rubocop:enable Metrics/ModuleLength
