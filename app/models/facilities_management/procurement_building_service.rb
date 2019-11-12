module FacilitiesManagement
  class ProcurementBuildingService < ApplicationRecord
    default_scope { order(created_at: :asc) }
    scope :require_volume, -> { where(code: [REQUIRE_VOLUME_CODES]) }
    scope :has_service_questions, -> { where(code: [SERVICES_AND_QUESTIONS.pluck(:code)]) }
    belongs_to :procurement_building, class_name: 'FacilitiesManagement::ProcurementBuilding', foreign_key: :facilities_management_procurement_building_id, inverse_of: :procurement_building_services

    # validates on :volume service question
    validates :no_of_appliances_for_testing, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    validates :no_of_building_occupants, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    validates :no_of_units_to_be_serviced, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    validates :size_of_external_area, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    validates :no_of_consoles_to_be_serviced, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume
    validates :tones_to_be_collected_and_removed, numericality: { greater_than: 0, only_integer: true, message: :invalid }, allow_blank: true, on: :volume

    # validates on :lifts
    validates :lift_data, length: { minimum: 1, maximum: 1000 }, on: :lifts
    validate :check_lift_data, on: :lifts

    # validates on :ppm_standards service question
    validate :service_ppm_standard_presence, on: :ppm_standards

    # validates on :ppm_standards service question
    validate :service_building_standard_presence, on: :building_standards

    # validates on :ppm_standards service question
    validate :service_cleaning_standard_presence, on: :cleaning_standards

    validate :validate_services, on: :all

    SERVICE_STANDARDS = %w[A B C].freeze

    REQUIRE_VOLUME_CODES = %w[E.4 G.1 G.3 G.5 K.1 K.2 K.3 K.7 K.4 K.5 K.6].freeze
    REQUIRE_PPM_STANDARDS_CODES = %w[C.1 C.2 C.3 C.4 C.5 C.6 C.11 C.12 C.13 C.14].freeze
    REQUIRE_CLEANING_STANDARDS_CODES = %w[G.1 G.2 G.3 G.4 G.5 G.6 G.7 G.8 G.9 G.10 G.11 G.12 G.13 G.14 G.15 G.16].freeze
    REQUIRE_BUILDING_STANDARDS_CODES = %w[C.7].freeze
    REQUIRE_LIFT_DATA_CODES = %w[C.5].freeze
    VOLUME_QUESTIONS = %i[no_of_appliances_for_testing no_of_building_occupants size_of_external_area no_of_consoles_to_be_serviced tones_to_be_collected_and_removed].freeze
    SERVICES_AND_QUESTIONS = [{ code: 'C.5', context: %i[lifts ppm_standards], questions: %i[total_floors_per_lift service_standard] },
                              { code: 'E.4', context: %i[volume], questions: [:no_of_appliances_for_testing] },
                              { code: 'G.1', context: %i[volume cleaning_standards], questions: %i[no_of_building_occupants service_standard] },
                              { code: 'G.3', context: %i[volume cleaning_standards], questions: %i[no_of_building_occupants service_standard] },
                              { code: 'G.5', context: %i[volume cleaning_standards], questions: %i[size_of_external_area service_standard] },
                              { code: 'H.4', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'H.5', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'I.1', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'I.2', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'I.3', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'I.4', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.1', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.2', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.3', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.4', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.5', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.6', context: %i[service_hours], questions: [:no_of_hours_of_service_provision] },
                              { code: 'K.1', context: %i[volume], questions: [:no_of_consoles_to_be_serviced] },
                              { code: 'K.2', context: %i[volume], questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.3', context: %i[volume], questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.4', context: %i[volume], questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.5', context: %i[volume], questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.6', context: %i[volume], questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.7', context: %i[volume], questions: [:no_of_units_to_be_serviced] },
                              { code: 'C.1', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'C.2', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'C.3', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'C.4', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'C.6', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'C.7', context: [:building_standards], questions: [:service_standard] },
                              { code: 'C.11', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'C.12', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'C.13', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'C.14', context: %i[ppm_standards], questions: [:service_standard] },
                              { code: 'G.4', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.2', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.6', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.7', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.8', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.9', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.10', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.11', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.12', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.13', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.14', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.15', context: %i[cleaning_standards], questions: [:service_standard] },
                              { code: 'G.16', context: %i[cleaning_standards], questions: [:service_standard] }].freeze

    def requires_volume?
      SERVICES_AND_QUESTIONS.select { |x| x[:code] == code && x[:context].include?(:volume) }&.any?
    end

    def requires_ppm_standards?
      SERVICES_AND_QUESTIONS.select { |x| x[:code] == code && x[:context].include?(:ppm_standards) }&.any?
    end

    def requires_building_standards?
      SERVICES_AND_QUESTIONS.select { |x| x[:code] == code && x[:context].include?(:building_standards) }&.any?
    end

    def requires_cleaning_standards?
      SERVICES_AND_QUESTIONS.select { |x| x[:code] == code && x[:context].include?(:cleaning_standards) }&.any?
    end

    def requires_lift_data?
      SERVICES_AND_QUESTIONS.select { |x| x[:code] == code && x[:context].include?(:lifts) }&.any?
    end

    def requires_which_contexts?
      SERVICES_AND_QUESTIONS.where { |x| x[:code] == code }&.select { |y| y[:context] }
    end

    def validate_services
      located_services = SERVICES_AND_QUESTIONS.select { |x| x[:code] == code }

      results = {}
      error_collection = ActiveModel::Errors.new(ProcurementBuildingService)

      validate_volume
      error_collection.merge!(errors)

      located_services.each do |service|
        service[:context].each do |context|
          results[context] = valid?(context)
          next if results[context]

          error_collection.merge!(errors)
        end
      end

      errors.merge! error_collection
      results
    end

    def services_status
      return { context: :na, ready: false } if code.blank?

      located_services = SERVICES_AND_QUESTIONS.select { |x| x[:code] == code }

      return { context: :unknown, ready: false } unless located_services.any?

      results = {}

      located_services.each do |service|
        service[:context].each do |context|
          results[code.to_sym] = {} unless results.key?(code.to_sym)
          results[code.to_sym].merge!(context.to_sym => valid?(context))
        end
      end

      results
    end

    private

    def check_lift_data
      errors.add(:lift_data, :required, position: 0) if lift_data.blank?

      Array(lift_data).each_with_index do |value, index|
        errors.add(:lift_data.to_sym, :greater_than, position: index) if value.to_i.zero?

        errors.add(:lift_data.to_sym, :less_than, position: index) if value.to_i > 1000

        errors.add(:lift_data.to_sym, :not_an_integer, position: index) unless value.to_i.to_s == value
      end
    end

    def service_ppm_standard_presence
      errors.add(:service_standard, I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank') + ' ' + name[0, 1].downcase + name[1, name.length]) if service_standard.blank? && requires_ppm_standards?
    end

    def service_building_standard_presence
      errors.add(:service_standard, I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank') + ' ' + name[0, 1].downcase + name[1, name.length]) if service_standard.blank? && requires_building_standards?
    end

    def service_cleaning_standard_presence
      errors.add(:service_standard, I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank') + ' ' + name[0, 1].downcase + name[1, name.length]) if service_standard.blank? && requires_cleaning_standards?
    end

    # rubocop:disable Rails/Validation
    def validate_volume
      located_services = SERVICES_AND_QUESTIONS.select { |x| x[:code] == code }
      return true if located_services.empty?

      located_services.each do |located_service|
        next unless located_service[:context].include?(:volume)

        located_service[:questions].each do |question|
          validates_numericality_of(question.to_sym, greater_than: 0, only_integer: true, message: :invalid) if VOLUME_QUESTIONS.include?(q)
        end
      end
    end
    # rubocop:enable Rails/Validation
  end
end
