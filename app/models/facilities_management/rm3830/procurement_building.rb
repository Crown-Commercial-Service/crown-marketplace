module FacilitiesManagement
  module RM3830
    class ProcurementBuilding < ApplicationRecord
      include ServiceQuestionsConcern

      scope :active, -> { where(active: true) }
      scope :order_by_building_name, -> { joins(:building).merge(FacilitiesManagement::Building.order(FacilitiesManagement::Building.arel_table['building_name'].lower.asc)) }
      scope :requires_service_information, -> { select { |pb| pb.service_codes.any? { |code| ServicesAndQuestions.codes.include?(code) } } }
      belongs_to :procurement, foreign_key: :facilities_management_rm3830_procurement_id, inverse_of: :procurement_buildings
      has_many :procurement_building_services, foreign_key: :facilities_management_rm3830_procurement_building_id, inverse_of: :procurement_building, dependent: :destroy
      accepts_nested_attributes_for :procurement_building_services, allow_destroy: true
      belongs_to :building, class_name: 'FacilitiesManagement::Building', optional: true
      delegate :full_address, to: :building
      delegate :address_no_region, to: :building

      validate :service_code_selection, on: :buildings_and_services
      validate :services_valid?, on: :procurement_building_services
      validate :validate_internal_area, on: :gia
      validate :validate_external_area, on: :external_area

      before_validation :cleanup_service_codes
      after_save :update_procurement_building_services

      amoeba do
        include_association :procurement_building_services
      end

      def service_names
        @service_names ||= begin
          service_code_order = FacilitiesManagement::RM3830::StaticData.work_packages.pluck('code')

          Service.where(code: service_codes).sort_by { |service| service_code_order.index(service.code) }.pluck(:name)
        end
      end

      # rubocop:disable Metrics/AbcSize, Rails/SkipsModelValidations
      def freeze_building_data
        # This freezes the GIA so if a user changes it later, it doesn't affect procurements in progress
        update_columns(
          gia: building.gia,
          external_area: building.external_area,
          building_type: building.building_type,
          security_type: building.security_type,
          address_town: building.address_town,
          address_line_1: building.address_line_1,
          address_line_2: building.address_line_2,
          address_postcode: building.address_postcode,
          address_region: building.address_region,
          address_region_code: building.address_region_code,
          building_name: building.building_name,
          description: building.description,
          other_security_type: building.other_security_type,
          other_building_type: building.other_building_type,
        )
      end
      # rubocop:enable Metrics/AbcSize, Rails/SkipsModelValidations

      def name
        building.building_name
      end

      def validate_spreadsheet_gia(gia, building_name)
        errors.add(:building, :gia_too_small, building_name:) if requires_internal_area? && gia.to_i.zero?
      end

      def validate_spreadsheet_external_area(external_area, building_name)
        errors.add(:building, :external_area_too_small, building_name:) if requires_external_area? && external_area.to_i.zero?
      end

      def missing_region?
        building.address_region_code.blank? || building.address_region.blank?
      end

      def sorted_procurement_building_services
        service_order = StaticData.work_packages.pluck('code').freeze
        procurement_building_services.sort_by { |procurement_building_service| service_order.index(procurement_building_service.code) }
      end

      def service_selection_complete?
        service_codes.any? && service_code_selection_error_code.nil?
      end

      def complete?
        return true unless requires_service_questions?

        area_complete? && volumes_complete? && standards_complete?
      end

      def requires_service_questions?
        service_codes.intersect?(services_requiring_questions)
      end

      def building_internal_area
        procurement.building_data_frozen? ? gia : building.gia
      end

      def building_external_area
        procurement.building_data_frozen? ? external_area : building.external_area
      end

      def requires_building_area?
        requires_external_area? || requires_internal_area?
      end

      def internal_area_incomplete?
        requires_internal_area? && building_internal_area.zero?
      end

      def external_area_incomplete?
        requires_external_area? && building_external_area.zero?
      end

      private

      def service_code_selection
        return unless active
        return errors.add(:service_codes, :invalid) if service_codes.empty?

        service_code_selection_validation
      end

      def cleanup_service_codes
        self.service_codes = service_codes.compact_blank
      end

      def services_valid?
        errors.add(:procurement_building_services, :invalid) && errors.add(:base, :services_invalid) unless complete?
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

      def service_code_selection_validation
        add_selection_error(service_code_selection_error_code)
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      def service_code_selection_error_code
        case service_codes.sort
        when ['O.1']
          0
        when ['N.1']
          1
        when ['M.1']
          2
        when ['M.1', 'O.1']
          3
        when ['N.1', 'O.1']
          4
        when ['M.1', 'N.1']
          5
        when ['M.1', 'N.1', 'O.1']
          6
        else
          7 if service_codes.include?('G.1') && service_codes.include?('G.3')
        end
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      def add_selection_error(index)
        return unless index

        errors.add(:service_codes, SERVICE_SELECTION_INVALID_TYPE[index])
      end

      def validate_internal_area
        errors.add(:building, :gia_too_small, building_name: name) if internal_area_incomplete?
      end

      def validate_external_area
        errors.add(:building, :external_area_too_small, building_name: name) if external_area_incomplete?
      end

      def requires_external_area?
        @requires_external_area ||= services_requiring_external_area.intersect?(service_codes)
      end

      def requires_internal_area?
        @requires_internal_area ||= services_requiring_gia.intersect?(service_codes)
      end

      def area_complete?
        !internal_area_incomplete? && !external_area_incomplete?
      end

      def volumes_complete?
        procurement_building_services.where(code: services_requiring_volumes).all? { |pbs| pbs.uval.present? }
      end

      def standards_complete?
        procurement_building_services.where(code: services_requiring_service_standards).pluck(:service_standard).all?(&:present?)
      end

      SERVICE_SELECTION_INVALID_TYPE = %i[invalid_billable invalid_helpdesk invalid_cafm invalid_cafm_billable invalid_helpdesk_billable invalid_cafm_helpdesk invalid_cafm_helpdesk_billable invalid_cleaning].freeze
    end
  end
end
