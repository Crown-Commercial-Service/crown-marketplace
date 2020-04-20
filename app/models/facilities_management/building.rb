require 'uk_postcode'
module FacilitiesManagement
  class Building < ApplicationRecord
    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :buildings

    attr_accessor :postcode_entry, :address

    before_save :populate_other_data, :determine_status
    before_validation :determine_status
    after_find :populate_json_attribute
    after_save :populate_json_attribute

    after_initialize do |building|
      building.postcode_entry = building.address_postcode if building.postcode_entry.blank?
    end

    validates :building_name, presence: true, on: %i[new edit all]
    validates :gia, presence: true, on: %i[gia all]
    validates :gia, numericality: { only_integer: true }, allow_blank: true
    validates :security_type, presence: true, on: %i[security all]
    validates :building_type, presence: true, on: %i[type all]
    validates :address_region, presence: true, on: %i[new edit all], if: -> { address_postcode.present? && address_line_1.present? }
    validates :address_postcode, presence: true, on: %i[new edit all], if: -> { postcode_entry.blank? }
    validates :address_postcode, presence: true, on: %i[add_address]
    validates :address_town, presence: true, on: %i[all add_address]
    validates :address_line_1, presence: true, on: %i[all add_address], if: -> { address_postcode.present? }
    validates :address_line_1, presence: true, on: %i[add_address]
    validate :address_selection, on: %i[new edit all]
    validate :postcode_format, on: %i[new edit all add_address], if: -> { address_postcode.present? }
    validates :other_building_type, presence: true, on: %i[type all], if: -> { building_type == 'other' }
    validates :other_security_type, presence: true, on: %i[security all], if: -> { security_type == 'other' }

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

    def populate_row
      populate_row_from_json(self[:building_json].deep_symbolize_keys)
    end

    def building_standard
      STANDARD_BUILDING_TYPES.include?(building_type) ? 'STANDARD' : 'NON-STANDARD'
    end

    private

    def populate_other_data
      self.user_email = Base64.encode64(user.email.to_s) unless user.nil?
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def determine_status
      self.status = if building_name.present? && address_postcode.present? && address_region_code.present? &&
                       building_type.present? && security_type.present? && gia.present?
                      'Ready'
                    else
                      'Incomplete'
                    end
    end

    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

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
      self.building_name       = building_json[:building_name] || building_json[:name]
      self.description         = building_json[:description]
      self.region              = building_json[:region]
      self.building_type       = building_json['building-type'.to_sym]
      self.security_type       = building_json['security-type'.to_sym]
      self.gia                 = building_json[:gia]
      self.address_town        = building_json[:address]['fm-address-town'.to_sym]
      self.address_line_1      = building_json[:address]['fm-address-line-1'.to_sym]
      self.address_line_2      = building_json[:address]['fm-address-line-2'.to_sym]
      self.address_region      = building_json[:address]['fm-address-region'.to_sym] || building_json[:address]['fm-nuts-region'.to_sym]
      self.address_postcode    = building_json[:address]['fm-address-postcode'.to_sym]
      self.address_region_code = building_json[:address]['fm-address-region-code'.to_sym]
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

    STANDARD_BUILDING_TYPES = ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations',
                               'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary School', 'Special Schools',
                               'Universities and Colleges', 'Doctors, Dentists and Health Clinics', 'Nursery and Care Homes'].freeze
    BUILDING_TYPES          = [{ id: 'General-office---Customer-Facing', title: 'General office - Customer Facing', caption: 'General office areas and customer facing areas.' },
                               { id: 'General-office---Non-Customer-Facing', title: 'General office - Non Customer Facing', caption: 'General office areas and non-customer facing areas.' },
                               { id: 'Call-Centre-Operations', title: 'Call Centre Operations', caption: 'Call centre operations.' },
                               { id: 'Warehouses', title: 'Warehouses', caption: 'Large storage facility with limited office space and low density occupation by supplier personnel.' },
                               { id: 'Restaurant-and-Catering-Facilities', title: 'Restaurant and Catering Facilities', caption: 'Areas including restaurants, deli-bars and coffee lounges areas used exclusively for consuming food and beverages.' },
                               { id: 'Pre-School', title: 'Pre-School', caption: 'Pre-school, including crèche, nursery and after-school facilities.' },
                               { id: 'Primary-School', title: 'Primary School', caption: 'Primary school facilities.' },
                               { id: 'Secondary-School', title: 'Secondary School', caption: 'Secondary school facilities.' },
                               { id: 'Special-Schools', title: 'Special Schools', caption: 'Special school facilities.' },
                               { id: 'Universities-and-Colleges', title: 'Universities and Colleges', caption: "\tUniversity and college, including on and off site campus facilities but excluding student residential accommodation facilities." },
                               { id: 'Doctors,-Dentists-and-Health-Clinics', title: 'Doctors, Dentists and Health Clinics', caption: "\tCommunity led facilities including doctors, dentists and health clinics." },
                               { id: 'Nursery-and-Care-Homes', title: 'Nursery and Care Homes', caption: "\tNursery and care home facilities." },
                               { id: 'Data-Centre-Operations', title: 'Data Centre Operations', caption: 'Data centre operation.' },
                               { id: 'External-parks,-grounds-and-car-parks', title: 'External parks, grounds and car parks', caption: "\tExternal car parks and grounds including externally fixed assets - such as fences, gates, fountains etc." },
                               { id: 'Laboratory', title: 'Laboratory', caption: 'Includes all Government facilities where the standard of cleanliness is high, access is restricted and is not public facing.' },
                               { id: 'Heritage-Buildings', title: 'Heritage Buildings', caption: 'Buildings of historical or cultural significance.' },
                               { id: 'Nuclear-Facilities', title: 'Nuclear Facilities', caption: 'Areas associated with Nuclear activities.' },
                               { id: 'Animal-Facilities', title: 'Animal Facilities', caption: 'Areas associated with the housing of animals such as dog kennels and stables.' },
                               { id: 'Custodial-Facilities', title: 'Custodial Facilities', caption: 'Facilities relating to the detention of personnel such as prisons and detention centres.' },
                               { id: 'Fire-and-Police-Stations', title: 'Fire and Police Stations', caption: 'Areas associated with emergency services.' },
                               { id: 'Production-Facilities', title: 'Production Facilities', caption: 'An environment centred around a fabrication or production facility, typically with restricted access.' },
                               { id: 'Workshops', title: 'Workshops', caption: 'Areas where works are undertaken such as joinery or metal working facilities' },
                               { id: 'Garages', title: 'Garages', caption: 'Areas where motor vehicles are cleaned, serviced, repaired and maintained.' },
                               { id: 'Shopping-Centres', title: 'Shopping Centres', caption: 'Areas where retail services are delivered to the public.' },
                               { id: 'Museums-or-Galleries', title: 'Museums or Galleries', caption: 'Areas are generally open to the public with some restrictions in place from time to time. Some facilities have no public access.' },
                               { id: 'Fitness-or-Training-Establishments', title: 'Fitness or Training Establishments', caption: 'Areas associated with fitness and leisure such as swimming pools, gymnasia, fitness centres and internal / external sports facilities.' },
                               { id: 'Residential-Buildings', title: 'Residential Buildings', caption: 'Residential accommodation / areas.' },
                               { id: 'Port-and-Airport-buildings', title: 'Port and Airport buildings', caption: 'Areas associated with air and sea transportation and supporting facilities, such as airports, aerodromes and dock areas.' },
                               { id: 'List-X-Property', title: 'List X Property', caption: "A commercial site (i.e. non-Government) on UK soil that is approved to hold UK government protectively marked information marked as 'confidential' and above. It is applied to a company's specific site and not a company as a whole." },
                               { id: 'Hospitals', title: 'Hospitals', caption: 'Areas including mainstream medical, healthcare facilities such as hospitals and medical centres.' },
                               { id: 'Mothballed-/-Vacant-/-Disposal', title: 'Mothballed / Vacant / Disposal', caption: 'Areas which are vacant or awaiting disposal where no services are being undertaken.' }].freeze
  end
end
