require 'facilities_management/services_and_questions'
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
    serialize :service_hours, ServiceHours

    # Lookup data for 'constants' are taken from this service object
    services_and_questions = ServicesAndQuestions.new

    # validates on :volume service question
    validate :validate_volume, on: :volume # this validator will valid the appropriate field for the given service

    # validates on :lifts
    validates :lift_data, length: { minimum: 1, maximum: 1000 }, on: :lifts
    validate :validate_lift_data, on: :lifts
    validate :service_hours_complete?, on: :service_hours

    # validates on the service_standard service question
    validate :validate_ppm_standard_presence, on: :ppm_standards
    validate :validate_building_standard_presence, on: :building_standards
    validate :validate_cleaning_standard_presence, on: :cleaning_standards

    # validates the entire row for all contexts - any appropriately invalid will validate as false
    validate :validate_services, on: :all

    define_method(:this_service) do
      @this_service ||= services_and_questions.service_detail(code)
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
    SERVICES_DEFINITION = services_and_questions.service_collection
    REQUIRE_VOLUME_CODES = services_and_questions.get_codes_by_context(:volume)

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

    def requires_service_hours?
      required_contexts.include?(:service_hours)
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

    def uval
      if requires_volume?
        send(required_contexts[:volume].first)
      elsif requires_lift_data?
        lift_data.map(&:to_i).inject(&:+)
      elsif requires_service_hours?
        service_hours.total_hours_annually.to_f.round(2)
      else
        procurement_building.building.building_json[:gia]
      end
    end

    private

    def service_hours_complete?
      errors.merge!(service_hours.errors) if service_hours.invalid?
    end

    # rubocop:disable Metrics/AbcSize
    def validate_lift_data
      errors.add(:lift_data, :required, position: 0) if lift_data.blank?

      errors.add(:lift_data, :above_maximum) if lift_data.size > 99

      Array(lift_data).each_with_index do |value, index|
        errors.add(:lift_data.to_sym, :greater_than, position: index) if value.to_i.zero?

        errors.add(:lift_data.to_sym, :less_than, position: index) if value.to_i > 1000

        errors.add(:lift_data.to_sym, :not_an_integer, position: index) unless value.to_i.to_s == value
      end
    end
    # rubocop:enable Metrics/AbcSize

    def validate_ppm_standard_presence
      validate_standard if validation_needed_for?(:ppm_standards)
    end

    def validate_building_standard_presence
      validate_standard if validation_needed_for?(:building_standards)
    end

    def validate_cleaning_standard_presence
      validate_standard if validation_needed_for?(:cleaning_standards)
    end

    def validation_needed_for?(context)
      this_service[:context].keys.include?(context)
    end

    def validate_standard
      errors.add(:service_standard, "#{I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank')} #{name[0, 1].downcase}#{name[1, name.length]}") if service_standard.blank?
    end

    # Checks that each field for each question
    # in the collection of VOLUME_QUESTIONS is correctly filled
    # according to it's specified context (:volume) and specific questions
    # rubocop:disable Rails/Validation, Metrics/AbcSize
    def validate_volume
      return if this_service.empty?

      return unless this_service[:context].key?(:volume)

      invalid = if ['K.1', 'K.2', 'K.3', 'K.4', 'K.5', 'K.6', 'K.7'].include? this_service[:code]
                  "invalid_#{this_service[:code].downcase.tr('.', '')}".to_sym
                else
                  :invalid
                end

      this_service[:context][:volume].each do |question|
        validates_numericality_of(question.to_sym, greater_than: 0, less_than_or_equal_to: 999999999, only_integer: true, message: invalid) if send(this_service[:context][:volume].first).present?
      end
    end

    # rubocop:enable Rails/Validation, Metrics/AbcSize
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
  end
end
