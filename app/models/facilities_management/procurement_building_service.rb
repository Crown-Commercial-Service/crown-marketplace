require 'facilities_management/procurement_buildings'
# This module pertains to the control and validation of the facilities_management_procurement_building_services table
# The main requirement is to drive the UI - there are lookups in the class that enable decisions as to which
# view to the present to the user and also, how to validate that data for both input from the UI and also from
# the perspective of the facilities_management_procurement that needs to know if it's buildings and services are completed
module FacilitiesManagement
  class ProcurementBuildingService < ApplicationRecord
    default_scope { order(created_at: :asc) }
    scope :require_volume, -> { where(code: [REQUIRE_VOLUME_CODES]) }
    scope :has_service_questions, -> { where(code: [SERVICES_DEFINITION.pluck(:code)]) }
    belongs_to :procurement_building, class_name: 'FacilitiesManagement::ProcurementBuilding', foreign_key: :facilities_management_procurement_building_id, inverse_of: :procurement_building_services

    # Lookup data for 'constants' are taken from this service object
    # services_and_questions = ServicesAndQuestions.new

    # validates on :volume service question
    validate :validate_volume, on: :volume # this validator will valid the appropriate field for the given service

    # validates on :lifts
    validates :lift_data, length: { minimum: 1, maximum: 1000 }, on: :lifts
    validate :validate_lift_data, on: :lifts

    # validates on the service_standard service question
    validate :validate_standard_presence, on: %i[ppm_standards building_standards cleaning_standards]

    # validates the entire row for all contexts - any appropriately invalid will validate as false
    validate :validate_services, on: :all

    def this_service
      @this_service ||= get_service_detail
    end

    # Processes each question of each service item and captures the question and answer in @service_answers_store
    def answer_store
      @answer_store ||= { code: this_service[:code], contexts: this_service[:context], questions: get_answers(this_service[:questions]) }
    end

    # Process each service by validating each context and gathers the errors for any context
    def context_validations
      @context_validations ||= answer_store[:contexts].map { |ctx| { ctx[0] => context_errors(ctx[0]) } }.reduce({}, :update)
    end

    # The options given in the service standards pages
    SERVICE_STANDARDS = %w[A B C].freeze

    # A set of methods used to confirm validation
    def requires_volume?
      required_contexts.include?(:volume)
    end

    def requires_ppm_standards?
      required_contexts.include?(:ppm_standards)
    end

    def requires_building_standards?
      required_contexts.include?(:building_standards)
    end

    def requires_cleaning_standards?
      required_contexts.include?(:cleaning_standards)
    end

    def requires_lift_data?
      required_contexts.include?(:lifts)
    end

    def required_contexts
      @required_contexts ||= this_service[:context]
    end

    # Goes through each context, gathering errors of each validation
    # (valid? clears errors so an internal collection is used)
    # Builds a map of context => error collection
    # Restores object's :errors collection to be the sum of all validations errors
    def validate_services
      return if this_service.blank?

      errors.merge!(context_errors([required_contexts.keys]))
    end

    # Returns a hash of all contexts and the valid? status for each
    def services_status
      return { context: :na, ready: false } if code.blank?

      return { context: :unknown, ready: false } if this_service[:context].empty?

      answer_store.merge(validity: context_validations)
    end

    private

    def validate_lift_data
      errors.add(:lift_data, :required, position: 0) if lift_data.blank?

      Array(lift_data).each_with_index do |value, index|
        errors.add(:lift_data.to_sym, :greater_than, position: index) if value.to_i.zero?

        errors.add(:lift_data.to_sym, :less_than, position: index) if value.to_i > 1000

        errors.add(:lift_data.to_sym, :not_an_integer, position: index) unless value.to_i.to_s == value
      end
    end

    def validate_standard_presence
      errors.add(:service_standard, "#{I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank')} #{name[0, 1].downcase}#{name[1, name.length]}") if service_standard.blank?
    end

    # Checks that each field for each question
    # in the collection of VOLUME_QUESTIONS is correctly filled
    # according to it's specified context (:volume) and specific questions
    # rubocop:disable Rails/Validation
    def validate_volume
      return if this_service.empty?

      return unless this_service[:context].key?(:volume)

      this_service[:context][:volume].each do |question|
        validates_numericality_of(question.to_sym, greater_than: 0, only_integer: true, message: :invalid)
      end
    end

    # rubocop:enable Rails/Validation
    # gathers the answers for a set of questions
    # in an array of question => answer key-value pairs
    def get_answers(questions)
      questions.map { |q| { question: q, answer: self[q] } }
    end

    def context_errors(*contexts)
      return nil if contexts.blank?

      error_collection = ActiveModel::Errors.new(ProcurementBuildingService)
      contexts.flatten.each do |ctx|
        valid?(ctx)
        error_collection.merge!(errors)
      end

      error_collection
    end

    define_method(:get_service_detail) do
      result = { code: code, context: {}, questions: [] }

      SERVICE_DECLARATIONS.select { |x| x[:code] == code }.each do |svc|
        result[:context].merge! svc[:context]
        result[:questions] |= svc[:questions]
      end

      result
    end

    CONTEXT_QUESTIONS =
      { lifts: %i[lift_data].freeze,
        ppm_standards: %i[service_standard].freeze,
        building_standards: %i[service_standard].freeze,
        cleaning_standards: %i[service_standard].freeze,
        volume: %i[no_of_appliances_for_testing no_of_building_occupants size_of_external_area no_of_consoles_to_be_serviced tones_to_be_collected_and_removed].freeze,
        service_hours: %i[no_of_hours_of_service_provision].freeze }.freeze

    SERVICE_DECLARATIONS = [{ code: 'C.5', context: { lifts: CONTEXT_QUESTIONS[:lifts] }, questions: CONTEXT_QUESTIONS[:lifts] },
                            { code: 'C.5', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:lifts] + CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'E.4', context: { volume: [:no_of_appliances_for_testing] }, questions: [:no_of_appliances_for_testing] },
                            { code: 'G.1', context: { volume: [:no_of_building_occupants], cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: %i[no_of_building_occupants] + CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.3', context: { volume: [:no_of_building_occupants], cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: %i[no_of_building_occupants] + CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.5', context: { volume: [:size_of_external_area], cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: %i[size_of_external_area] + CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'H.4', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'I.1', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'H.5', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'I.2', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'I.3', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'I.4', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'J.1', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'J.2', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'J.3', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'J.4', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'J.5', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'J.6', context: { service_hours: CONTEXT_QUESTIONS[:service_hours] }, questions: CONTEXT_QUESTIONS[:service_hours] },
                            { code: 'K.1', context: { volume: [:no_of_consoles_to_be_serviced] }, questions: [:no_of_consoles_to_be_serviced] },
                            { code: 'K.2', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
                            { code: 'K.3', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
                            { code: 'K.4', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
                            { code: 'K.5', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
                            { code: 'K.6', context: { volume: [:tones_to_be_collected_and_removed] }, questions: [:tones_to_be_collected_and_removed] },
                            { code: 'K.7', context: { volume: [:no_of_units_to_be_serviced] }, questions: [:no_of_units_to_be_serviced] },
                            { code: 'C.1', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'C.2', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'C.3', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'C.4', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'C.6', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'C.7', context: { building_standards: CONTEXT_QUESTIONS[:building_standards] }, questions: CONTEXT_QUESTIONS[:building_standards] },
                            { code: 'C.11', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'C.12', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'C.13', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'C.14', context: { ppm_standards: CONTEXT_QUESTIONS[:ppm_standards] }, questions: CONTEXT_QUESTIONS[:ppm_standards] },
                            { code: 'G.4', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.2', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.6', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.7', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.8', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.9', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.10', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.11', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.12', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.13', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.14', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.15', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] },
                            { code: 'G.16', context: { cleaning_standards: CONTEXT_QUESTIONS[:cleaning_standards] }, questions: CONTEXT_QUESTIONS[:cleaning_standards] }].freeze

    # A collection of service code, their UI/Validation contexts, and the attributes that are being populated by the view
    SERVICES_DEFINITION = SERVICE_DECLARATIONS
    REQUIRE_VOLUME_CODES = SERVICES_DEFINITION.select { |svc| svc[:context].include?(:volume) }.map { |svc| svc[:code] }.freeze # %w[E.4 G.1 G.3 G.5 K.1 K.2 K.3 K.7 K.4 K.5 K.6].freeze
  end
end
