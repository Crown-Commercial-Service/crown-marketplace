class FacilitiesManagement::RM3830::ServicesAndQuestions
  def self.context_questions
    @context_questions ||= define_context_questions
  end

  def self.service_collection
    @service_collection ||= gather_services
  end

  # Reduces the set of service declarations into a single hash for the given service code
  def self.service_detail(code)
    result = { code: code, context: {}, questions: [] }

    service_collection.select { |x| x[:code] == code }.each do |svc|
      result[:context].merge! svc[:context]
      result[:questions] |= svc[:questions]
    end

    result
  end

  def self.get_codes_by_context(context)
    service_collection.select { |svc| svc[:context].include?(context.to_sym) }.pluck(:code)
  end

  def self.get_codes_by_question(question)
    service_collection.select { |svc| svc[:questions].include?(question.to_sym) }.pluck(:code)
  end

  def self.codes
    service_collection.pluck(:code)
  end

  def self.define_context_questions
    { lifts: %i[lift_data].freeze,
      ppm_standards: %i[service_standard].freeze,
      building_standards: %i[service_standard].freeze,
      cleaning_standards: %i[service_standard].freeze,
      volume: %i[no_of_appliances_for_testing no_of_building_occupants no_of_consoles_to_be_serviced tones_to_be_collected_and_removed no_of_units_to_be_serviced].freeze,
      service_hours: %i[service_hours].freeze }
  end

  def self.gather_services
    service_hours_questions = context_questions[:service_hours]
    cleaning_questions = context_questions[:cleaning_standards]
    ppm_questions = context_questions[:ppm_standards]

    [{ code: 'C.5', context: { lifts: context_questions[:lifts] }, questions: context_questions[:lifts] },
     { code: 'C.5', context: { ppm_standards: ppm_questions }, questions: context_questions[:lifts] + ppm_questions },
     { code: 'E.4', context: { volume: [:no_of_appliances_for_testing] }, questions: [:no_of_appliances_for_testing] },
     { code: 'G.1', context: { volume: [:no_of_building_occupants], cleaning_standards: cleaning_questions }, questions: %i[no_of_building_occupants] + cleaning_questions },
     { code: 'G.3', context: { volume: [:no_of_building_occupants], cleaning_standards: cleaning_questions }, questions: %i[no_of_building_occupants] + cleaning_questions },
     { code: 'G.5', context: { cleaning_standards: cleaning_questions }, questions: cleaning_questions },
     { code: 'H.4', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'I.1', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'H.5', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'I.2', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'I.3', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'I.4', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'J.1', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'J.2', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'J.3', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'J.4', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'J.5', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'J.6', context: { service_hours: service_hours_questions }, questions: service_hours_questions },
     { code: 'K.1', context: { volume: [:no_of_consoles_to_be_serviced] }, questions: [:no_of_consoles_to_be_serviced] },
     { code: 'K.2', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
     { code: 'K.3', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
     { code: 'K.4', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
     { code: 'K.5', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
     { code: 'K.6', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
     { code: 'K.7', context: { volume: [:no_of_units_to_be_serviced] }, questions: [:no_of_units_to_be_serviced] },
     { code: 'C.1', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'C.2', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'C.3', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'C.4', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'C.6', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'C.7', context: { building_standards: context_questions[:building_standards] }, questions: context_questions[:building_standards] },
     { code: 'C.11', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'C.12', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'C.13', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'C.14', context: { ppm_standards: ppm_questions }, questions: ppm_questions },
     { code: 'G.4', context: { cleaning_standards: cleaning_questions }, questions: cleaning_questions }].freeze
  end
end
