module FacilitiesManagement::Beta::ProcurementBuildingsHelper
  def service_questions(pbs)
    pbs.this_service
  end

  def volume_question(pbs)
    service_questions(pbs)[:questions].first
  end

  def ppm_standard_question(pbs)
    service_questions(pbs)[:ppm_standards][:questions]
  end

  def building_standard_question(pbs)
    service_questions(pbs)[:building_standards][:questions]
  end

  def cleaning_standard_question(pbs)
    service_questions(pbs)[:cleaning_standards][:questions]
  end

  def question_type(service, question)
    if question == :service_standard
      return 'ppm_standards' if service.requires_ppm_standards?

      return 'building_standards' if service.requires_building_standards?

      return 'cleaning_standards' if service.requires_cleaning_standards?
    elsif service.requires_volume?
      'volume'
    end
  end

  def checked?(object_value, value)
    object_value == value
  end
end
