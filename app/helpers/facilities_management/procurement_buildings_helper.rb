module FacilitiesManagement::ProcurementBuildingsHelper
  def ppm_standard_question(pbs)
    [] unless pbs.this_service[:context].key? :ppm_standards
    pbs.this_service[:context][:ppm_standards]&.first
  end

  def building_standard_question(pbs)
    [] unless pbs.this_service[:context].key? :building_standards
    pbs.this_service[:context][:building_standards]&.first
  end

  def cleaning_standard_question(pbs)
    [] unless pbs.this_service[:context].key? :cleaning_standards
    pbs.this_service[:context][:cleaning_standards]&.first
  end

  def service_standard(service)
    return 'ppm_standards' if service.requires_ppm_standards?

    return 'building_standards' if service.requires_building_standards?

    'cleaning_standards' if service.requires_cleaning_standards?
  end

  def checked?(object_value, value)
    object_value == value
  end

  def cell_class(qa_h)
    css_class = ['govuk-table__cell', 'govuk-!-padding-right-2']
    css_class << 'govuk-border-bottom_none' if qa_h[:question] == :service_hours && qa_h[:answer].present?
    css_class.join(' ')
  end

  def building_summary(title, vlaue)
    content_tag :div, class: 'govuk-grid-row govuk-!-margin-bottom-6' do
      content_tag :div, class: 'govuk-grid-column-two-thirds' do
        capture do
          concat(content_tag(:h3, title, class: 'govuk-heading-s govuk-!-margin-bottom-2'))
          concat(content_tag(:span, vlaue, class: 'govuk-body'))
        end
      end
    end
  end

  def regions
    Postcode::PostcodeCheckerV2.find_region(@building.address_postcode.delete(' ')).map { |region| region[:region] }
  end

  def get_service_question(question)
    case question
    when :lift_data
      'lifts'
    when :service_hours
      'service_hours'
    when :service_standard
      'service_standards'
    when :no_of_appliances_for_testing, :no_of_building_occupants, :no_of_consoles_to_be_serviced, :tones_to_be_collected_and_removed, :no_of_units_to_be_serviced
      'volumes'
    else
      'area'
    end
  end
end
