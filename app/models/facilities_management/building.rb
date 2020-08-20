require 'uk_postcode'
module FacilitiesManagement
  class Building < ApplicationRecord
    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :buildings

    attr_accessor :postcode_entry, :address

    before_save :populate_other_data, :determine_status, :populate_json_attribute
    before_validation :determine_status
    after_find :populate_json_attribute

    after_initialize do |building|
      building.postcode_entry = building.address_postcode if building.postcode_entry.blank?
    end

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

    validates :building_name, presence: true, uniqueness: { scope: :user }, length: { maximum: 25 }, on: %i[new edit all]
    validates :description, length: { maximum: 50 }, on: %i[new edit all]

    validates :gia, presence: true, on: %i[gia all]
    validates :gia, numericality: { only_integer: true }, on: %i[gia all]
    validates :external_area, presence: true, on: %i[gia all]
    validates :external_area, numericality: { only_integer: true }, on: %i[gia all]
    validate  :combined_external_area_and_gia_greater_than_zero, on: %i[gia all]

    validates :address_line_1, presence: true, length: { maximum: 100 }, on: %i[all add_address], if: -> { address_postcode.present? }
    validates :address_line_1, presence: true, length: { maximum: 100 }, on: %i[add_address]
    validates :address_town, presence: true, length: { maximum: 30 }, on: %i[all add_address]
    validates :address_postcode, presence: true, on: %i[new edit all], if: -> { postcode_entry.blank? }
    validates :address_postcode, presence: true, on: %i[add_address]
    validate :postcode_format, on: %i[new edit all add_address], if: -> { address_postcode.present? }
    validates :address_region, presence: true, on: %i[new edit all], if: -> { address_postcode.present? && address_line_1.present? }
    validate :address_selection, on: %i[new edit all]

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

    def building_json=(json)
      populate_row_from_json(json.deep_symbolize_keys)
      attributes['building_json'] = json
    end

    def building_json
      if building_name.present?
        json_from_row
      else
        attributes['building_json']
      end
    end

    def populate_json_attribute
      self[:building_json] = json_from_row.deep_symbolize_keys if building_name.present?
      populate_row_from_json(self[:building_json].deep_symbolize_keys) if building_name.blank? && self&.building_json&.dig('name').present?
    end

    def building_standard
      STANDARD_BUILDING_TYPES.include?(building_type) ? 'STANDARD' : 'NON-STANDARD'
    end

    def full_address
      "#{address_line_1 + ', ' if address_line_1.present?}
      #{address_line_2 + ', ' if address_line_2.present?}
      #{address_town + ', ' if address_town.present?}
      #{address_region + ', ' if address_region.present?}
      #{address_postcode}"
    end

    private

    def populate_other_data
      self.user_email = Base64.encode64(user.email.to_s) unless user.nil?
    end

    def determine_status
      self.status = if building_ready?
                      'Ready'
                    else
                      'Incomplete'
                    end
    end

    def building_ready?
      building_name.present? && address_postcode.present? && address_region_code.present? && building_type.present? && security_type.present? && combined_area_positive?
    end

    def combined_area_positive?
      false if gia.nil? || external_area.nil?

      (gia.to_i + external_area.to_i).positive?
    end

    def json_from_row
      {
        id: id,
        name: building_name,
        description: description,
        region: region,
        gia: gia,
        'building-type': building_type,
        'security-type': security_type,
        address: {
          'fm-address-town': address_town,
          'fm-address-line-1': address_line_1,
          'fm-address-line-2': address_line_2,
          'fm-address-region': address_region,
          'fm-address-region-code': address_region_code,
          'fm-address-postcode': address_postcode
        }
      }.symbolize_keys
    end

    # rubocop:disable Metrics/AbcSize
    def populate_row_from_json(building_json)
      self.building_name = building_json[:building_name] || building_json[:name]
      self.description   = building_json[:description]
      self.region        = building_json[:region]
      self.building_type = building_json['building-type'.to_sym]
      self.security_type = building_json['security-type'.to_sym]
      self.gia           = building_json[:gia].to_s.to_i
      if building_json&.dig(:address).present?
        self.address_town        = building_json[:address]['fm-address-town'.to_sym]
        self.address_line_1      = building_json[:address]['fm-address-line-1'.to_sym]
        self.address_line_2      = building_json[:address]['fm-address-line-2'.to_sym]
        self.address_region      = building_json[:address]['fm-address-region'.to_sym] || building_json[:address]['fm-nuts-region'.to_sym]
        self.address_postcode    = building_json[:address]['fm-address-postcode'.to_sym]
        self.address_region_code = building_json[:address]['fm-address-region-code'.to_sym]
      end
      determine_status
    end

    # rubocop:enable Metrics/AbcSize
    def address_selection
      return if postcode_entry.blank?

      pc = UKPostcode.parse(postcode_entry)
      pc.full_valid? ? errors.delete(:postcode_entry) : errors.add(:postcode_entry, :invalid)

      errors.add(:address, :not_selected) if address_line_1.blank? && pc.full_valid?
    end

    def postcode_format
      pc = UKPostcode.parse(address_postcode)
      pc.full_valid? ? errors.delete(:address_postcode) : errors.add(:address_postcode, :invalid)
    end

    def combined_external_area_and_gia_greater_than_zero
      return if (gia.to_i + external_area.to_i).positive?

      errors.add(:gia, :combined_area)
      errors.add(:external_area, :combined_area)
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
