module FacilitiesManagement::ProcurementBuildingsHelper
  def volume_question(pbs)
    [] unless pbs.this_service[:context].key? :volume
    pbs.this_service[:context][:volume]&.first
  end

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

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def question_type(service, question)
    return 'service_hours' if question == :service_hours

    if question == :service_standard
      return 'ppm_standards' if service.requires_ppm_standards?

      return 'building_standards' if service.requires_building_standards?

      return 'cleaning_standards' if service.requires_cleaning_standards?
    elsif service.requires_volume?
      'volume'
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  def service_standard(service)
    return 'ppm_standards' if service.requires_ppm_standards?

    return 'building_standards' if service.requires_building_standards?

    'cleaning_standards' if service.requires_cleaning_standards?
  end

  def checked?(object_value, value)
    object_value == value
  end
end
