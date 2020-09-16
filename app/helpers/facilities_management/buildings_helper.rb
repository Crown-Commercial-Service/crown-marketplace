module FacilitiesManagement::BuildingsHelper
  def address?(building)
    return false if building.blank?

    building.address_town || building.address_line_1 || building.address_postcode || building.address_region
  end

  def address_in_a_line(building)
    [building.address_line_1, building.address_line_2, building.address_town].reject(&:blank?).join(', ') + " #{building.address_postcode}"
  end

  def building_row_text(attribute, building, text)
    case attribute
    when :address
      address_in_a_line(building)
    when :gia, :external_area
      number_with_delimiter(text.to_i, delimiter: ',') + ' sqm'
    when :building_type
      type_description(building_type_description(text), building, :other_building_type)
    when :security_type
      type_description(text.capitalize, building, :other_security_type)
    else
      text
    end
  end

  def type_description(text, building, attribute)
    if text == 'Other'
      "#{text} — #{building[attribute].truncate(150)}"
    else
      text
    end
  end

  def edit_link(change_answer, step)
    link_to((change_answer ? t('facilities_management.buildings.show.answer_question_text') : t('facilities_management.buildings.show.change_text')), edit_facilities_management_building_path(@page_data[:model_object].id, step: step), role: 'link', class: 'govuk-link')
  end

  def cant_find_address_link
    add_address_facilities_management_building_path(@page_data[:model_object].id)
  end

  def continuation_params(page_defs, form, step)
    case step
    when 'building_details'
      [page_defs, form, true, false, true]
    when 'security'
      [page_defs, form, false]
    else
      [page_defs, form]
    end
  end

  def open_state_of_building_details(building)
    return false if building[:building_type].blank?

    if building.building_type == 'other' || building.errors.key?(:other_building_type) ||
       FacilitiesManagement::Building::BUILDING_TYPES[0..1].map { |bt| bt[:title] }.exclude?(building[:building_type])
      true
    else
      false
    end
  end

  def building_type_description(building_type_id)
    building_type = FacilitiesManagement::Building::BUILDING_TYPES.find { |bt| bt[:id] == building_type_id }
    if building_type.present?
      building_type[:title].capitalize
    else
      building_type_id.capitalize
    end
  end

  def building_type_caption(building_type)
    content_tag(:span, class: 'govuk-caption-m govuk-!-margin-top-1') do
      concat(building_type[:caption])
      if FacilitiesManagement::Building.da_building_type? building_type[:id]
        concat(tag(:hr, class: 'govuk-section-break govuk-!-margin-top-1'))
        concat(govuk_tag_with_text(:grey, t('common.da_eligible')))
      end
    end
  end

  def postcode_form_field(form, label_text)
    css_classes = %w[govuk-!-margin-top-3]
    form_group_css = ['govuk-form-group']
    form_group_css += ['govuk-form-group--error'] if form.object.errors[:address_postcode].any?

    content_tag :div, class: css_classes, data: { propertyname: 'address_postcode' } do
      content_tag :div, class: form_group_css, data: {} do
        concat display_label(:address_postcode, label_text, 'facilities_management_building_address_postcode', 'facilities_management_building_address_postcode-info') if label_text.present?
        concat display_postcode_errors(form.object)
        yield
      end
    end
  end

  def display_postcode_errors(model_object)
    collection = validation_messages(model_object.class.name.underscore.downcase.to_sym, :address_postcode)
    return if collection.empty?

    content_tag :div, class: 'error-collection potenital-error', property_name: 'address_postcode' do
      postcode_errors(model_object, collection)
    end
  end

  def postcode_errors(model_object, error_collection)
    content_tag :label, class: "govuk-error-message #{'govuk-visually-hidden' unless model_object.errors.any?}",
                        for: 'postcode_entry',
                        id: 'address_postcode-error' do
      error_collection.each do |key, val|
        tag_validation_type = key == :blank ? :required : key
        concat(content_tag(:span, val, class: "govuk-error-message #{'govuk-visually-hidden' unless attribute_has_errors(model_object, :address_postcode, key)}", data: { propertyname: 'address_postcode', validation: tag_validation_type }))
      end
    end
  end
end
