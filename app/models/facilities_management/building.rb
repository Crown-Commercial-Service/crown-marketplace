require 'uk_postcode'
module FacilitiesManagement
  class Building < ApplicationRecord
    belongs_to :user,
               inverse_of: :buildings

    scope :order_by_building_name, -> { order(Arel.sql('lower(building_name)')) }

    before_save :determine_status
    before_validation :determine_status

    BUILDING_TYPES = [{ id: 'General office - Customer Facing', title: 'General office - customer facing', caption: 'General office areas and customer facing areas.' },
                      { id: 'General office - Non Customer Facing', title: 'General office - non customer facing', caption: 'General office areas and non-customer facing areas.' },
                      { id: 'Call Centre Operations', title: 'Call centre operations', caption: '' },
                      { id: 'Warehouses', title: 'Warehouses', caption: 'Large storage facility with limited office space and low density occupation by supplier personnel.' },
                      { id: 'Restaurant and Catering Facilities', title: 'Restaurant and catering facilities', caption: 'Areas including restaurants, deli-bars, coffee lounges and areas used exclusively for consuming food and beverages.' },
                      { id: 'Pre-School', title: 'Pre-school', caption: 'Pre-school, including crèche, nursery and after-school facilities.' },
                      { id: 'Primary School', title: 'Primary school', caption: 'Primary school facilities.' },
                      { id: 'Secondary Schools', title: 'Secondary school', caption: 'Secondary school facilities.' },
                      { id: 'Special Schools', title: 'Special schools', caption: 'Special school facilities.' },
                      { id: 'Universities and Colleges', title: 'Universities and colleges', caption: 'University and college, including on and off site campus facilities but excluding student residential accommodation facilities.' },
                      { id: 'Community - Doctors, Dentist, Health Clinic', title: 'Doctors, dentists and health clinics', caption: 'Community led facilities including doctors, dentists and health clinics.' },
                      { id: 'Nursing and Care Homes', title: 'Nursery and care homes', caption: 'Nursery and care home facilities.' },
                      { id: 'Data-Centre-Operations', title: 'Data centre operations', caption: '' },
                      { id: 'External-parks,-grounds-and-car-parks', title: 'External parks, grounds and car parks', caption: 'External car parks and grounds including externally fixed assets. For example: fences, gates, fountains.' },
                      { id: 'Laboratory', title: 'Laboratory', caption: 'Includes all Government facilities where the standard of cleanliness is high, access is restricted and is not public facing.' },
                      { id: 'Heritage-Buildings', title: 'Heritage buildings', caption: 'Buildings of historical or cultural significance.' },
                      { id: 'Nuclear-Facilities', title: 'Nuclear facilities', caption: 'Areas associated with nuclear activities.' },
                      { id: 'Animal-Facilities', title: 'Animal facilities', caption: 'Areas associated with the housing of animals such as dog kennels and stables.' },
                      { id: 'Custodial-Facilities', title: 'Custodial facilities', caption: 'Facilities relating to the detention of personnel such as prisons and detention centres.' },
                      { id: 'Fire-and-Police-Stations', title: 'Fire and police stations', caption: 'Areas associated with emergency services.' },
                      { id: 'Production-Facilities', title: 'Production facilities', caption: 'An environment centered around a fabrication or production facility, typically with restricted access.' },
                      { id: 'Workshops', title: 'Workshops', caption: 'Areas where works are undertaken such as joinery or metal working facilities.' },
                      { id: 'Garages', title: 'Garages', caption: 'Areas where motor vehicles are cleaned, serviced, repaired and maintained.' },
                      { id: 'Shopping-Centres', title: 'Shopping centres', caption: 'Areas where retail services are delivered to the public.' },
                      { id: 'Museums-or-Galleries', title: 'Museums or galleries', caption: 'Areas that are generally open to the public with some restrictions in place from time to time. Some facilities have no public access.' },
                      { id: 'Fitness-or-Training-Establishments', title: 'Fitness or training establishments', caption: 'Areas associated with fitness and leisure such as swimming pools, gymnasia, fitness centres and internal or external sports facilities.' },
                      { id: 'Residential-Buildings', title: 'Residential buildings', caption: 'Residential accommodation or areas.' },
                      { id: 'Port-and-Airport-buildings', title: 'Port and airport buildings', caption: 'Areas associated with air and sea transportation and supporting facilities. For example: airports, aerodromes and dock areas.' },
                      { id: 'List-X-Property', title: 'List x property', caption: "A commercial site (that is non-government) on UK soil that is approved to hold UK government protectively marked information marked as 'confidential' and above. It is applied to a company's specific site and not a company as a whole." },
                      { id: 'Hospitals', title: 'Hospitals', caption: 'Areas including mainstream medical, healthcare facilities such as hospitals and medical centres.' },
                      { id: 'Mothballed-/-Vacant-/-Disposal', title: 'Mothballed or vacant or disposal', caption: 'Areas which are vacant or awaiting disposal where no services are being undertaken.' }].freeze

    validate :remove_excess_spaces_from_building_name, on: %i[new building_details all]
    validates :building_name, presence: true, uniqueness: { scope: :user }, length: { maximum: 50 }, on: %i[new building_details all]
    validates :description, length: { maximum: 50 }, on: %i[new building_details all]

    validates :gia, :external_area, presence: true, on: %i[gia all]
    validates :gia, :external_area, numericality: { only_integer: true, less_than_or_equal_to: 999999999 }, on: %i[gia all]
    validate  :combined_external_area_and_gia_greater_than_zero, on: %i[gia all]

    validates :address_line_1, presence: true, length: { maximum: 100 }, on: %i[all add_address], if: -> { address_postcode.present? }
    validates :address_line_1, presence: true, length: { maximum: 100 }, on: %i[add_address]
    validates :address_line_2, length: { maximum: 100 }, on: %i[all add_address], if: -> { address_postcode.present? }
    validates :address_line_2, length: { maximum: 100 }, on: %i[add_address]
    validates :address_town, presence: true, length: { maximum: 30 }, on: %i[all add_address]
    validates :address_postcode, presence: true, on: %i[new building_details all], if: -> { address_postcode.blank? }
    validates :address_postcode, presence: true, on: %i[add_address]
    validate :postcode_format, on: %i[new building_details all add_address], if: -> { address_postcode.present? }
    validate :address_selection, on: %i[new building_details all]
    validate :address_region_selection, on: %i[new building_details all], if: -> { address_postcode.present? && address_line_1.present? }

    before_validation proc { convert_other(:building_type) }, on: %i[type all], if: -> { building_type == 'Other' }
    before_validation proc { remove_other(:other_building_type) }, on: %i[type all], unless: -> { building_type == 'other' }
    before_validation :convert_building_type, on: %i[type all], unless: -> { building_type == 'other' }
    validates :building_type, presence: true, inclusion: { in: BUILDING_TYPES.map { |type| type[:id] } + ['other'] }, on: %i[type all]
    validates :other_building_type, presence: true, on: %i[type all], if: -> { building_type == 'other' }
    validate proc { text_area_max_length(:other_building_type, 150) }, on: %i[type all], if: -> { building_type == 'other' }

    before_validation proc { convert_other(:security_type) }, on: %i[security all], if: -> { security_type == 'Other' }
    before_validation proc { remove_other(:other_security_type) }, on: %i[security all], unless: -> { security_type == 'other' }
    validates :security_type, presence: true, on: %i[security all]
    validate :security_type_selection, on: %i[security all]
    validates :other_security_type, presence: true, on: %i[security all], if: -> { security_type == 'other' }
    validate proc { text_area_max_length(:other_security_type, 150) }, on: %i[security all], if: -> { security_type == 'other' }

    def building_standard
      STANDARD_BUILDING_TYPES.include?(building_type) ? 'STANDARD' : 'NON-STANDARD'
    end

    def self.da_building_type?(building_type)
      STANDARD_BUILDING_TYPES.include?(building_type)
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

    def remove_other(attribute)
      self[attribute] = nil
    end

    def convert_other(attribute)
      self[attribute] = 'other'
    end

    def text_area_max_length(attribute, maximum)
      errors.add(attribute, :too_long) if self[attribute].present? && self[attribute].gsub("\r\n", "\r").length > maximum
    end

    def security_type_selection
      fm_security_types = FacilitiesManagement::SecurityTypes&.all&.map(&:title)
      fm_security_types = [] if fm_security_types.nil?
      errors.add(:security_type, :inclusion) unless (fm_security_types + ['other']).include? security_type
    end

    SPREADSHEET_BUILDING_TYPES = ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations', 'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary School', 'Special Schools', 'Universities and Colleges', 'Doctors, Dentists and Health Clinics', 'Nursery and Care Homes', 'Data Centre Operations', 'External parks, grounds and car parks', 'Laboratory', 'Heritage Buildings', 'Nuclear Facilities', 'Animal Facilities', 'Custodial Facilities', 'Fire and Police Stations', 'Production Facilities', 'Workshops', 'Garages', 'Shopping Centres', 'Museums /Galleries', 'Fitness / Training Establishments', 'Residential Buildings', 'Port and Airport buildings', 'List X Property', 'Hospitals', 'Mothballed / Vacant / Disposal'].freeze

    BUILDING_TYPES_CONVERSION = SPREADSHEET_BUILDING_TYPES.map.with_index { |type, index| [type, BUILDING_TYPES[index][:id]] }.to_h.freeze

    def convert_building_type
      self.building_type = BUILDING_TYPES_CONVERSION[building_type] || building_type
    end

    # The standard building types are: "General office - Customer Facing", "General office - Non Customer Facing", "Call Centre Operations",
    #                                  "Warehouses", "Restaurant and catering facilities", "Pre-school", "Primary school", "Secondary school",
    #                                  "Special schools", "Universities and colleges", "Doctors, dentists and health clinics", "Nursery and care homes"
    STANDARD_BUILDING_TYPES = BUILDING_TYPES[0..11].map { |bt| bt[:id] }.freeze
  end
end
