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
    services_and_questions = ServicesAndQuestions.new

    # validates on :volume service question
    # validates :no_of_appliances_for_testing, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    # validates :no_of_building_occupants, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    # validates :no_of_units_to_be_serviced, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    # validates :size_of_external_area, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    # validates :no_of_consoles_to_be_serviced, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    # validates :tones_to_be_collected_and_removed, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    validate :validate_volume, on: :volume # this validator will valid the appropriate field for the given service

    # validates on :lifts
    validates :lift_data, length: { minimum: 1, maximum: 1000 }, on: :lifts
    validate :validate_lift_data, on: :lifts

    # validates on the service_standard service question
    validate :validate_standard_presence, on: :ppm_standards
    validate :validate_standard_presence, on: :building_standards
    validate :validate_standard_presence, on: :cleaning_standards

    # validates on :ppm_standards service question
    validate :service_building_standard_presence, on: :building_standards

    # validates on :ppm_standards service question
    validate :service_cleaning_standard_presence, on: :cleaning_standards

    # validates the entire row for all contexts - any appropriately invalid will validate as false
    validate :validate_services, on: :all

    # Methods to act as accessors to the computed results of validation
    # Filters the main service collection to the current selected :code and places in @instance_service_store
    def this_service
      @this_service ||= SERVICES_DEFINITION.select { |x| x[:code] == code }
    end

    # Processes each question of each service item and captures the question and answer in @service_answers_store
    def answer_store
      @answer_store ||= this_service.map { |service_hash| { code: service_hash[:code], contexts: service_hash[:context], questions: get_answers(service_hash[:questions]) } }
    end

    # Process each service by validating each context and gathers the errors for any context
    def context_validations
      @context_validations ||= answer_store.map { |sa| sa.merge!(validity: sa[:contexts].map { |ctx| { ctx[0] => context_errors([ctx[1].reduce]) } }.reduce({}, :update)) }
    end

    # The options given in the service standards pages
    SERVICE_STANDARDS = %w[A B C].freeze

    # A set of questions that pertain to :volume validation context - :volume has multiple fields valid for specific questions
    VOLUME_QUESTIONS = services_and_questions.context_questions[:volume].freeze

    # A collection of service code, their UI/Validation contexts, and the attributes that are being populated by the view
    SERVICES_DEFINITION = services_and_questions.service_collection.freeze

    REQUIRE_VOLUME_CODES = services_and_questions.service_collection.select { |svc| svc[:context].include?(:volume) }.map { |svc| svc[:code] }.freeze # %w[E.4 G.1 G.3 G.5 K.1 K.2 K.3 K.7 K.4 K.5 K.6].freeze

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
      @required_contexts ||= this_service&.map { |y| y[:context] }.reduce({}, :update)
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

    # Goes through each context, gathering errors of each validation
    # (valid? clears errors so an internal collection is used)
    # Builds a map of context => error collection
    # Restores object's :errors collection to be the sum of all validations errors
    def validate_services
      results = {}
      return results if this_service.blank?

      context_validations.each { |cv| results.merge!(cv) }
      errors.merge!(context_errors([required_contexts.keys]))
      results
    end

    # Returns a hash of all contexts and the valid? status for each
    def services_status
      return { context: :na, ready: false } if code.blank?

      return { context: :unknown, ready: false } unless this_service.any?

      answer_store.merge(context_validations)
    end

    private

    # Executes validate_volume and gathers the error collection from that validation
    def volume_validation_results?(error_collection)
      validate_volume
      error_collection.merge(errors)
      errors.any?
    end

    def validate_lift_data
      errors.add(:lift_data, :required, position: 0) if lift_data.blank?

      Array(lift_data).each_with_index do |value, index|
        errors.add(:lift_data.to_sym, :greater_than, position: index) if value.to_i.zero?

        errors.add(:lift_data.to_sym, :less_than, position: index) if value.to_i > 1000

        errors.add(:lift_data.to_sym, :not_an_integer, position: index) unless value.to_i.to_s == value
      end
    end

    def validate_standard_presence
      errors.add(:service_standard, I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank') + ' ' + name[0, 1].downcase + name[1, name.length]) if service_standard.blank?
    end

    def service_ppm_standard_presence
      errors.add(:service_standard, "#{I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank')} #{name[0, 1].downcase}#{name[1, name.length]}") if service_standard.blank? && requires_ppm_standards?
    end

    def service_building_standard_presence
      errors.add(:service_standard, I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank') + ' ' + name[0, 1].downcase + name[1, name.length]) if service_standard.blank? && requires_building_standards?
    end

    def service_cleaning_standard_presence
      errors.add(:service_standard, I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank') + ' ' + name[0, 1].downcase + name[1, name.length]) if service_standard.blank? && requires_cleaning_standards?
    end

    # gathers the answers for a set of questions
    # in an array of question => answer key-value pairs
    def get_answers(questions)
      questions.map { |q| { question: q, answer: self[q] } }
    end

    # Checks that each field for each question
    # in the collection of VOLUME_QUESTIONS is correctly filled
    # according to it's specified context (:volume) and specific questions
    # rubocop:disable Rails/Validation
    def validate_volume
      return true if this_service.empty?

      this_service.select { |svc| svc.value?(:volume) }.dig(:questions).each do |question|
        validates_numericality_of(question.to_sym, greater_than: 0, only_integer: true, message: :invalid) if VOLUME_QUESTIONS.include?(question)
      end
    end
    # rubocop:enable Rails/Validation
  end
end
