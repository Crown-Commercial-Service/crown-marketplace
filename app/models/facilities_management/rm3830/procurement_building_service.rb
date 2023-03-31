module FacilitiesManagement
  module RM3830
    class ProcurementBuildingService < ApplicationRecord
      default_scope { order(created_at: :asc) }
      scope :require_volume, -> { where(code: [REQUIRE_VOLUME_CODES]) }
      belongs_to :procurement_building, class_name: 'FacilitiesManagement::RM3830::ProcurementBuilding', foreign_key: :facilities_management_rm3830_procurement_building_id, inverse_of: :procurement_building_services

      has_many :lifts, class_name: 'FacilitiesManagement::RM3830::ProcurementBuildingServiceLift', foreign_key: :facilities_management_rm3830_procurement_building_service_id, inverse_of: :procurement_building_service, dependent: :destroy, index_errors: true
      accepts_nested_attributes_for :lifts, allow_destroy: true, reject_if: :more_than_max_lifts?

      # Lookup data for 'constants' are taken from this service object
      services_and_questions = ServicesAndQuestions

      # validates on :volume service question
      validate :validate_volume, on: :volume # this validator will valid the appropriate field for the given service

      # validates on :lifts
      validate :validate_lift_data, on: :lifts

      # validations on :service_hours
      validates :service_hours, numericality: { allow_nil: false, only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 999999999 }, on: :service_hours
      validates :detail_of_requirement, presence: true, on: :service_hours
      validate :validate_detail_of_requirement_max_length, on: :service_hours

      # validates on the service_standard service question
      validate :validate_standard, on: %i[service_standard ppm_standards building_standards cleaning_standards]

      # validates the entire row for all contexts - any appropriately invalid will validate as false
      validate :validate_services, on: :all

      amoeba do
        include_association :lifts
      end

      define_method(:this_service) do
        @this_service ||= services_and_questions.service_detail(code)
      end

      # Processes each question of each service item and captures the question and answer in @service_answers_store
      def answer_store
        @answer_store ||= { code: this_service[:code], contexts: this_service[:context], questions: get_answers(this_service[:questions]) }
      end

      # The options given in the service standards pages
      SERVICE_STANDARDS = %w[A B C].freeze
      SERVICES_DEFINITION = services_and_questions.service_collection
      REQUIRE_VOLUME_CODES = services_and_questions.get_codes_by_context(:volume)

      # A set of methods used to confirm validation
      def requires_unit_of_measure?
        requires_volume? || requires_lift_data? || requires_service_hours?
      end

      def requires_volume?
        required_contexts.include?(:volume)
      end

      def requires_service_standard?
        required_contexts.keys.intersect?(STANDARD_TYPES)
      end

      def requires_lift_data?
        required_contexts.include?(:lifts)
      end

      def requires_service_hours?
        required_contexts.include?(:service_hours)
      end

      def requires_external_area?
        ['G.5'].include? code
      end

      def requires_internal_area?
        Service.full_gia_services.include? code
      end

      def uses_only_internal_area?
        Service.gia_services.include? code
      end

      def required_contexts
        @required_contexts ||= this_service[:context]
      end

      def required_volume_contexts
        return {} if required_contexts.nil?

        volume_contexts = @required_contexts.except(*STANDARD_TYPES)
        volume_contexts[:gia] = [:gia] if requires_internal_area?
        volume_contexts[:external_area] = [:external_area] if requires_external_area?

        volume_contexts
      end

      # Goes through each context, gathering errors of each validation
      # (valid? clears errors so an internal collection is used)
      # Builds a map of context => error collection
      # Restores object's :errors collection to be the sum of all validations errors
      def validate_services
        return if this_service.blank?

        validate_for_all_contexts(required_contexts.keys)
      end

      def uval
        if requires_volume?
          send(required_contexts[:volume].first)
        elsif requires_lift_data?
          sum_number_of_floors unless lifts.empty?
        elsif requires_service_hours?
          service_hours
        elsif requires_external_area?
          procurement_building.external_area
        else
          procurement_building.gia
        end
      end

      def service_missing_framework_price?(rate_model)
        rate_model.framework_rate_for(code, service_standard).nil?
      end

      def service_missing_benchmark_price?(rate_model)
        rate_model.benchmark_rate_for(code, service_standard).nil?
      end

      def special_da_service?
        Service.special_da_service?(code)
      end

      def sum_number_of_floors
        lifts.sum(:number_of_floors)
      end

      def gia
        procurement_building.building.gia
      end

      def external_area
        procurement_building.building.external_area
      end

      def lift_data
        lifts.map(&:number_of_floors)
      end

      MAX_NUMBER_OF_LIFTS = 99

      private

      STANDARD_TYPES = %i[ppm_standards building_standards cleaning_standards].freeze

      def validate_lift_data
        errors.add(:lifts, :required) if lifts.empty?

        errors.add(:lifts, :above_maximum) if lifts.size > MAX_NUMBER_OF_LIFTS

        lifts.all?(&:valid?)
      end

      def more_than_max_lifts?
        lifts.reject(&:marked_for_destruction?).size >= MAX_NUMBER_OF_LIFTS
      end

      def validate_standard
        errors.add(:service_standard, :blank) if service_standard.blank? || SERVICE_STANDARDS.exclude?(service_standard)
      end

      # Checks that each field for each question
      # in the collection of VOLUME_QUESTIONS is correctly filled
      # according to it's specified context (:volume) and specific questions
      # rubocop:disable Rails/Validation
      def validate_volume
        return unless requires_volume?

        this_service[:context][:volume].each do |question|
          if self[question.to_sym].nil?
            errors.add(question.to_sym, :blank)
            break
          end

          validates_numericality_of(question.to_sym, greater_than: 0, less_than_or_equal_to: 999999999, only_integer: true, message: :invalid)
        end
      end
      # rubocop:enable Rails/Validation

      def validate_detail_of_requirement_max_length
        self.detail_of_requirement = ActionController::Base.helpers.strip_tags(detail_of_requirement)
        errors.add(:detail_of_requirement, :too_long) if detail_of_requirement.present? && detail_of_requirement.gsub("\r\n", "\r").length > 500
      end

      # gathers the answers for a set of questions
      # in an array of question => answer key-value pairs
      def get_answers(questions)
        questions.map { |q| { question: q, answer: self[q] } }
      end

      def validate_for_all_contexts(*contexts)
        return if contexts.blank?

        contexts.flatten.all? { |ctx| valid?(ctx) }
      end
    end
  end
end
