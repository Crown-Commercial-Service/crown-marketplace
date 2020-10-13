module ServiceQuestionsConcern
  extend ActiveSupport::Concern

  def service_quesions
    @service_quesions ||= FacilitiesManagement::ServicesAndQuestions
  end

  def services_requiring_volumes
    @services_requiring_volumes ||= VOLUME_QUESTIONS.map { |context| service_quesions.get_codes_by_context(context) }.flatten
  end

  def services_requiring_service_standards
    @services_requiring_service_standards ||= service_quesions.get_codes_by_question(:service_standard)
  end

  def services_requiring_service_hours
    @services_requiring_service_hours ||= service_quesions.get_codes_by_question(:service_hours)
  end

  def services_requiring_gia
    @services_requiring_gia ||= CCS::FM::Service.full_gia_services
  end

  def services_requiring_external_area
    @services_requiring_external_area ||= ['G.5']
  end

  def services_requiring_lift_data
    @services_requiring_lift_data ||= ['C.5']
  end

  def services_requiring_unit_of_measure
    @services_requiring_unit_of_measure ||= (services_requiring_volumes + services_requiring_gia + services_requiring_external_area).uniq
  end

  def services_requiring_questions
    @services_requiring_questions ||= (services_requiring_unit_of_measure + services_requiring_service_standards).uniq
  end

  def volume_contexts
    @volume_contexts ||= service_quesions.define_context_questions[:volume]
  end

  VOLUME_QUESTIONS = %i[lifts volume service_hours].freeze
end
