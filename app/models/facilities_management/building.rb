require 'uk_postcode'
module FacilitiesManagement
  class Building < ApplicationRecord
    belongs_to :user,
               inverse_of: :buildings

    scope :order_by_building_name, -> { order(Arel.sql('lower(building_name)')) }

    before_save :determine_status
    before_validation :determine_status

    with_options on: %i[all new building_details] do
      validate :remove_excess_spaces_from_building_name
      validates :building_name, presence: true, uniqueness: { scope: :user, error: :taken }, length: { maximum: 50 }
      validates :description, length: { maximum: 50 }
    end

    with_options on: %i[all gia] do
      validates :gia, :external_area, presence: true
      validates :gia, :external_area, numericality: { only_integer: true, less_than_or_equal_to: 999999999 }
      validate  :combined_external_area_and_gia_greater_than_zero
    end

    with_options on: :all, if: -> { address_postcode.present? } do
      validates :address_line_1, presence: true, length: { maximum: 100 }
      validates :address_line_2, length: { maximum: 100 }
      validates :address_town, presence: true, length: { maximum: 30 }
    end

    with_options on: %i[all new building_details] do
      validates :address_postcode, presence: true, if: -> { address_postcode.blank? }
      validate :postcode_format, if: -> { address_postcode.present? }
      validate :address_selection
      validate :address_region_selection, if: -> { address_postcode.present? && address_line_1.present? }
    end

    with_options on: :add_address do
      validates :address_line_1, presence: true, length: { maximum: 100 }
      validates :address_line_2, length: { maximum: 100 }
      validates :address_town, presence: true, length: { maximum: 30 }
      validates :address_postcode, presence: true
      validate :postcode_format, if: -> { address_postcode.present? }
    end

    with_options on: %i[all type] do
      before_validation :prepare_building_type_selection
      validates :building_type, presence: true
      validate :building_type_selection

      with_options if: -> { building_type == 'other' } do
        validates :other_building_type, presence: true
        validate { text_area_max_length(:other_building_type, 150) }
      end
    end

    with_options on: %i[all security] do
      before_validation :prepare_security_type_selection
      validates :security_type, presence: true
      validate :security_type_selection

      with_options if: -> { security_type == 'other' } do
        validates :other_security_type, presence: true
        validate { text_area_max_length(:other_security_type, 150) }
      end
    end

    def building_standard
      BuildingType.find(building_type).standard_building_type ? 'STANDARD' : 'NON-STANDARD'
    end

    def full_address
      [address_line_1, address_line_2, address_town, address_region, address_postcode].reject(&:blank?).join(', ')
    end

    def address_no_region
      [address_line_1, address_line_2, address_town, address_postcode].reject(&:blank?).join(', ')
    end

    def add_region_code_from_address_region
      regions = Postcode::PostcodeCheckerV2.find_region address_postcode.delete(' ')
      region = regions.select { |single_region| single_region[:region] == address_region }.first
      return if region.nil?

      self.address_region_code = region[:code]
    end

    def building_status
      if status == 'Ready'
        :completed
      else
        :incomplete
      end
    end

    private

    def determine_status
      self.status = if building_ready?
                      'Ready'
                    else
                      'Incomplete'
                    end
    end

    def remove_excess_spaces_from_building_name
      building_name&.squish!
    end

    def building_ready?
      building_name.present? && address_postcode.present? && address_region_code.present? && building_type.present? && security_type.present? && combined_area_positive?
    end

    def combined_area_positive?
      false if gia.nil? || external_area.nil?

      (gia.to_i + external_area.to_i).positive?
    end

    def address_selection
      return if address_postcode.blank?

      pc = UKPostcode.parse(address_postcode)
      pc.full_valid? ? errors.delete(:address_postcode) : errors.add(:address_postcode, :invalid)

      errors.add(:base, :not_selected) if address_line_1.blank? && pc.full_valid?
    end

    def postcode_format
      pc = UKPostcode.parse(address_postcode)
      pc.full_valid? ? errors.delete(:address_postcode) : errors.add(:address_postcode, :invalid)
    end

    def combined_external_area_and_gia_greater_than_zero
      return if errors[:gia].any? || errors[:external_area].any? || (gia.to_i + external_area.to_i).positive?

      errors.add(:gia, :combined_area)
      errors.add(:external_area, :combined_area)
    end

    def address_region_selection
      errors.add(:address_region, :blank) unless address_region.present? && address_region_code.present?
    end

    def prepare_building_type_selection
      self.building_type = 'other' if building_type == 'Other'
      return if building_type == 'other'

      self.other_building_type = nil
      convert_building_type
    end

    def prepare_security_type_selection
      self.security_type = 'other' if security_type == 'Other'
      self.other_security_type = nil unless security_type == 'other'
    end

    def text_area_max_length(attribute, maximum)
      errors.add(attribute, :too_long) if self[attribute].present? && self[attribute].gsub("\r\n", "\r").length > maximum
    end

    def building_type_selection
      fm_building_types = BuildingType&.all&.map(&:title) || []

      errors.add(:building_type, :inclusion) unless (fm_building_types + ['other']).include? building_type
    end

    def security_type_selection
      fm_security_types = SecurityType&.all&.map(&:title) || []

      errors.add(:security_type, :inclusion) unless (fm_security_types + ['other']).include? security_type
    end

    SPREADSHEET_BUILDING_TYPES = ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary School', 'Special Schools', 'Universities and Colleges', 'Doctors, Dentists and Health Clinics', 'Nursery and Care Homes', 'Data Centre Operations', 'External parks, grounds and car parks', 'Laboratory', 'Heritage Buildings', 'Nuclear Facilities', 'Animal Facilities', 'Custodial Facilities', 'Fire and Police Stations', 'Production Facilities', 'Workshops', 'Garages', 'Shopping Centres', 'Museums /Galleries', 'Fitness / Training Establishments', 'Residential Buildings', 'Port and Airport buildings', 'List X Property', 'Hospitals', 'Mothballed / Vacant / Disposal'].freeze

    BUILDING_TYPES_CONVERSION = SPREADSHEET_BUILDING_TYPES.zip(BuildingType.order(:sort_order).pluck(:title)).to_h.freeze

    def convert_building_type
      self.building_type = BUILDING_TYPES_CONVERSION[building_type] || building_type
    end
  end
end
