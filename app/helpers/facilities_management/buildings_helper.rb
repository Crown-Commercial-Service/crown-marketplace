module FacilitiesManagement::BuildingsHelper
  def building_rows
    {
      building_name: { value: @building.building_name, section: 'building_details' },
      building_description: { value: @building.description, section: 'building_details' },
      address: { value: @building.address_line_1, section: 'building_details' },
      region: {  value: @building.address_region, section: 'building_details' },
      gia: { value: @building.gia, section: 'building_area' },
      external_area: { value: @building.external_area, section: 'building_area' },
      building_type: { value: @building.building_type, section: 'building_type' },
      security_type: { value: @building.security_type, section: 'security_type' }
    }
  end

  def building_row_text(attribute, text)
    case attribute
    when :address
      address_in_a_line
    when :gia, :external_area
      "#{number_with_delimiter(text.to_i, delimiter: ',')} sqm"
    when :building_type
      type_description(building_type_description(text), :other_building_type)
    when :security_type
      type_description(text, :other_security_type)
    else
      text
    end
  end

  def address_in_a_line
    [@building.address_line_1, @building.address_line_2, @building.address_town].compact_blank.join(', ') + " #{@building.address_postcode}"
  end

  def type_description(text, attribute)
    if ['Other', 'other'].include?(text)
      "Other — #{@building[attribute].truncate(150)}"
    else
      text
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

  def section_number
    (SECTIONS.index(section) || 0) + 1
  end

  SECTIONS = %i[building_details building_area building_type security_type].freeze

  def should_building_details_be_open?
    @should_building_details_be_open ||= if @building.building_type.blank?
                                           false
                                         else
                                           @building.building_type == 'other' || @building.errors.key?(:other_building_type) || FacilitiesManagement::Building::BUILDING_TYPES[0..1].pluck(:id).exclude?(@building.building_type)
                                         end
  end

  def building_type_radio_button(form, building_type, disabled)
    tag.div(class: 'govuk-radios__item') do
      capture do
        concat(form.radio_button(:building_type, building_type[:id], class: 'govuk-radios__input', disabled: disabled))
        concat(
          form.label(:building_type, value: building_type[:id], class: 'govuk-label govuk-radios__label govuk-label--s') do
            concat(building_type[:title])
            concat(building_type_caption(building_type))
          end
        )
      end
    end
  end

  def building_type_caption(building_type)
    tag.span(class: 'govuk-caption-m govuk-!-margin-top-1') do
      concat(building_type[:caption])
      if building_type[:standard_building_type]
        concat(tag.hr(class: 'govuk-section-break govuk-!-margin-top-1'))
        concat(govuk_tag_with_text(:grey, t('common.da_eligible'))) if params[:framework] == 'RM3830'
      end
    end
  end

  def cant_find_address_link
    edit_path(@building, 'add_address')
  end

  def select_a_region_visible?
    @select_a_region_visible ||= @building.address_line_1.present? && @building.address_region.blank?
  end

  def full_region_visible?
    @full_region_visible ||= @building.address_region.present?
  end

  def multiple_regions?
    valid_regions.length > 1
  end

  def object_name(name)
    name
  end
end
