module FacilitiesManagement::ProcurementBuildingsHelper
  def cell_class(context, answer, errors)
    css_class = ['govuk-table__cell', 'govuk-!-padding-right-2']
    css_class << 'govuk-border-bottom_none' if errors || (context == :service_hours && answer.present?)
    css_class.join(' ')
  end

  def building_summary(title, vlaue)
    tag.div(class: 'govuk-grid-row govuk-!-margin-bottom-6') do
      tag.div(class: 'govuk-grid-column-two-thirds') do
        capture do
          concat(tag.h3(title, class: 'govuk-heading-s govuk-!-margin-bottom-2'))
          concat(tag.span(vlaue, class: 'govuk-body'))
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

  def procurement_building_status
    if @procurement_building.complete?
      [:blue, 'COMPLETE']
    else
      [:red, 'INCOMPLETE']
    end
  end

  def services_with_contexts(volume_procurement_building_services)
    volume_procurement_building_services.each do |service_with_context|
      yield(service_with_context[:procurement_building_service], service_with_context[:context])
    end
  end

  def form_object
    @step == 'missing_region' ? @building : @procurement_building
  end

  def question_id(service, context, question)
    [service.code, context, question].compact.join('-')
  end

  def internal_area_incomplete?
    @internal_area_incomplete ||= @procurement_building.internal_area_incomplete?
  end

  def external_area_incomplete?
    @external_area_incomplete ||= @procurement_building.external_area_incomplete?
  end

  def service_has_errors?(context)
    case context
    when :gia
      internal_area_incomplete?
    when :external_area
      external_area_incomplete?
    else
      false
    end
  end
end
