module FacilitiesManagement
  class ProcurementBuilding < ApplicationRecord
    scope :active, -> { where(active: true) }
    scope :order_by_building_name, -> { order(:building_name) }
    scope :requires_service_information, -> { select { |pb| pb.service_codes.any? { |code| FacilitiesManagement::ServicesAndQuestions.codes.include?(code) } } }
    belongs_to :procurement, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement_buildings
    has_many :procurement_building_services, foreign_key: :facilities_management_procurement_building_id, inverse_of: :procurement_building, dependent: :destroy
    accepts_nested_attributes_for :procurement_building_services, allow_destroy: true
    belongs_to :building, class_name: 'FacilitiesManagement::Building', optional: true
    delegate :full_address, to: :building

    validate :service_code_selection, on: :buildings_and_services
    validate :services_valid?, on: :procurement_building_services
    validate :validate_service_requirements, on: :service_requirements
    validate :services_present?, on: :procurement_building_services_present
    validate :validate_internal_area, on: :gia
    validate :validate_external_area, on: :external_area

    before_validation :cleanup_service_codes
    after_save :update_procurement_building_services

    amoeba do
      include_association :procurement_building_services
    end

    # rubocop:disable Metrics/AbcSize, Rails/SkipsModelValidations
    def set_gia
      # This freezes the GIA so if a user changes it later, it doesn't affect procurements in progress
      update_columns(
        gia: building.gia,
        external_area: building.external_area,
        region: building.region,
        building_type: building.building_type,
        security_type: building.security_type,
        address_town: building.address_town,
        address_line_1: building.address_line_1,
        address_line_2: building.address_line_2,
        address_postcode: building.address_postcode,
        address_region: building.address_region,
        address_region_code: building.address_region_code,
        building_name: building.building_name,
        building_json: building.building_json,
        description: building.description
      )
    end
    # rubocop:enable Metrics/AbcSize, Rails/SkipsModelValidations

    def name
      building.building_name
    end

    def validate_spreadsheet_gia(gia, building_name)
      errors.add(:building, :gia_too_small, building_name: building_name) if requires_internal_area? && gia.to_i.zero?
    end

    def validate_spreadsheet_external_area(external_area, building_name)
      errors.add(:building, :external_area_too_small, building_name: building_name) if requires_external_area? && external_area.to_i.zero?
    end

    def missing_region?
      building.address_region_code.nil? || building.address_region.nil?
    end

    def sorted_procurement_building_services
      service_order = FacilitiesManagement::StaticData.work_packages.map { |work_package| work_package['code'] }.freeze
      procurement_building_services.sort_by { |procurement_building_service| service_order.index(procurement_building_service.code) }
    end

    def complete?
      return true unless requires_service_questions?

      area_complete? && volumes_complete? && standards_complete?
    end

    def valid_on_continue?
      procurement.errors.add(:base, :services_not_present) && (return false) if service_codes.empty?

      valid?(:buildings_and_services) && valid?(:procurement_building_services) && valid?(:gia) && valid?(:external_area)
    end

    def requires_service_questions?
      return true if requires_internal_area? || requires_external_area?

      procurement_building_services.map(&:required_contexts).any?(&:present?)
    end

    def building_internal_area
      procurement.detailed_search? ? building.gia : gia
    end

    def building_external_area
      procurement.detailed_search? ? building.external_area : external_area
    end

    private

    def service_code_selection
      return unless active
      return errors.add(:service_codes, :invalid, building_name: building.building_name, building_id: id) if service_codes.empty?

      service_code_selection_validation
    end

    def cleanup_service_codes
      self.service_codes = service_codes.reject(&:blank?)
    end

    def services_present?
      errors.add(:service_codes, :at_least_one, building_name: name) if service_codes.empty?
    end

    def validate_service_requirements
      procurement_building_services.all? { |pbs| pbs.valid?(:gia) && pbs.valid?(:external_area) }
    end

    def services_valid?
      errors.add(:procurement_building_services, :invalid) && errors.add(:base, :services_invalid) unless procurement_building_services.all? { |pbs| pbs.answer_store[:questions].all? { |question| !question[:answer].nil? } }
    end

    def update_procurement_building_services
      (service_codes + procurement_building_services.map(&:code)).uniq.each do |service_code|
        if service_codes.include?(service_code)
          if procurement_building_services.find_by(code: service_code).blank?
            service = procurement_building_services.new(code: service_code, name: Service.find_by(code: service_code).try(:name))
            service.save(validate: false)
          end
        else
          procurement_building_services.find_by(code: service_code)&.destroy
        end
      end
    end

    def answers_present?
      procurement_building_services.all? do |pb|
        pb.answer_store[:questions].all? { |question| !question[:answer].nil? }
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def service_code_selection_validation
      case service_codes.sort
      when ['O.1']
        add_selection_error(0)
      when ['N.1']
        add_selection_error(1)
      when ['M.1']
        add_selection_error(2)
      when ['M.1', 'O.1']
        add_selection_error(3)
      when ['N.1', 'O.1']
        add_selection_error(4)
      when ['M.1', 'N.1']
        add_selection_error(5)
      when ['M.1', 'N.1', 'O.1']
        add_selection_error(6)
      else
        add_selection_error(7) if service_codes.include?('G.1') && service_codes.include?('G.3')
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def validate_internal_area
      errors.add(:building, :gia_too_small, building_name: name) if requires_internal_area? && building_internal_area.zero?
    end

    def validate_external_area
      errors.add(:building, :external_area_too_small, building_name: name) if requires_external_area? && building_external_area.zero?
    end

    def requires_external_area?
      service_codes.include? 'G.5'
    end

    def requires_internal_area?
      (CCS::FM::Service.full_gia_services & service_codes).any?
    end

    def add_selection_error(index)
      errors.add(:service_codes, SERVICE_SELECTION_INVALID_TYPE[index], building_name: building.building_name, building_id: id)
    end

    def area_complete?
      return false if requires_internal_area? && building_internal_area.zero?
      return false if requires_external_area? && building_external_area.zero?

      true
    end

    def volumes_complete?
      procurement_building_services.select(&:requires_unit_of_measure?).all? { |pbs| pbs.uval.present? }
    end

    def standards_complete?
      procurement_building_services.select(&:requires_service_standard?).all? { |pbs| pbs.service_standard.present? }
    end

    SERVICE_SELECTION_INVALID_TYPE = %i[invalid_billable invalid_helpdesk invalid_cafm invalid_cafm_billable invalid_helpdesk_billable invalid_cafm_helpdesk invalid_cafm_helpdesk_billable invalid_cleaning].freeze
  end
end
