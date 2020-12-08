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

  def open_state_of_building_details
    @open_state_of_building_details ||= should_building_details_be_open?
  end

  def should_building_details_be_open?
    return false if @page_data[:model_object][:building_type].blank?

    if @page_data[:model_object].building_type == 'other' || @page_data[:model_object].errors.key?(:other_building_type) ||
       FacilitiesManagement::Building::BUILDING_TYPES[0..1].map { |bt| bt[:id] }.exclude?(@page_data[:model_object][:building_type])
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

  def postcode_search_visible?
    @postcode_search_visible ||= @page_data[:model_object].address_postcode.blank? || @page_data[:model_object].errors[:address_postcode].any?
  end

  def postcode_change_visible?
    @postcode_change_visible ||= @page_data[:model_object].address_postcode.present? && @page_data[:model_object].errors[:address_postcode].none? && @page_data[:model_object].address_line_1.blank?
  end

  def select_an_address_visible?
    @select_an_address_visible ||= postcode_change_visible?
  end

  def full_address_visible?
    @full_address_visible ||= @page_data[:model_object].address_line_1.present?
  end

  def select_a_region_visible?
    @select_a_region_visible ||= @page_data[:model_object].address_line_1.present? && @page_data[:model_object].address_region.blank?
  end

  def full_region_visible?
    @full_region_visible ||= @page_data[:model_object].address_region.present?
  end

  def hidden_class(visible)
    'govuk-visually-hidden' unless visible
  end

  def input_visible?(visible)
    visible ? 0 : -1
  end
end
