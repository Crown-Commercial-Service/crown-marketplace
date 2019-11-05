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
    validates :lift_data, length: { minimum: 1, maximum: 99 }, on: :lifts
    validate :check_lift_data, on: :lifts

    # validates on :ppm_standards service question
    validate :service_standard_presence, on: :ppm_standards

    after_validation :cleanup_arra

    SERVICE_STANDARDS = %w[A B C].freeze
    REQUIRE_VOLUME_CODES = %w[E.4 G.1 G.3 G.5 K.1 K.2 K.3 K.7 K.4 K.5 K.6].freeze
    REQUIRE_PPM_STANDARDS_CODES = %w[C.1 C.2 C.3 C.4 C.5 C.6 C.11 C.12 C.13 C.14].freeze
    SERVICES_AND_QUESTIONS = [{ code: 'C.5', questions: %i[total_floors_per_lift service_standard] },
                              { code: 'E.4', questions: [:no_of_appliances_for_testing] },
                              { code: 'G.1', questions: %i[no_of_building_occupants service_standard] },
                              { code: 'G.3', questions: %i[no_of_building_occupants service_standard] },
                              { code: 'G.5', questions: %i[size_of_external_area service_standard] },
                              { code: 'H.4', questions: [:no_of_hours_of_service_provision] },
                              { code: 'H.5', questions: [:no_of_hours_of_service_provision] },
                              { code: 'I.1', questions: [:no_of_hours_of_service_provision] },
                              { code: 'I.2', questions: [:no_of_hours_of_service_provision] },
                              { code: 'I.3', questions: [:no_of_hours_of_service_provision] },
                              { code: 'I.4', questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.1', questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.2', questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.3', questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.4', questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.5', questions: [:no_of_hours_of_service_provision] },
                              { code: 'J.6', questions: [:no_of_hours_of_service_provision] },
                              { code: 'K.1', questions: [:no_of_consoles_to_be_serviced] },
                              { code: 'K.2', questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.3', questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.4', questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.5', questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.6', questions: [:tones_to_be_collected_and_removed] },
                              { code: 'K.7', questions: [:no_of_units_to_be_serviced] },
                              { code: 'C.1', questions: [:service_standard] },
                              { code: 'C.2', questions: [:service_standard] },
                              { code: 'C.3', questions: [:service_standard] },
                              { code: 'C.4', questions: [:service_standard] },
                              { code: 'C.6', questions: [:service_standard] },
                              { code: 'C.7', questions: [:service_standard] },
                              { code: 'C.11', questions: [:service_standard] },
                              { code: 'C.12', questions: [:service_standard] },
                              { code: 'C.13', questions: [:service_standard] },
                              { code: 'C.14', questions: [:service_standard] },
                              { code: 'G.4', questions: [:service_standard] }].freeze

    def requires_volume?
      REQUIRE_VOLUME_CODES.include?(code)
    end

    def requires_ppm_standards?
      REQUIRE_PPM_STANDARDS_CODES.include?(code)
    end

    private

    def check_lift_data
      errors.add(:lift_data, :required, position: 0) if lift_data.blank?

      Array(lift_data).each_with_index do |value, index|
        errors.add(:lift_data.to_sym, :greater_than, position: index) if value.to_i.zero?

        errors.add(:lift_data.to_sym, :less_than, position: index) if value.to_i > 99
      end
    end

    def service_standard_presence
      errors.add(:service_standard, I18n.t('activerecord.errors.models.facilities_management/procurement_building_service.attributes.service_standard.blank') + ' ' + name[0, 1].downcase + name[1, name.length]) if service_standard.blank? && requires_ppm_standards?
    end
  end
end
