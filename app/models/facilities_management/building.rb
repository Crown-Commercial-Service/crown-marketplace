module FacilitiesManagement
  class Building < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :buildings

    before_save :populate_other_data, :determine_status
    before_validation :determine_status
    after_find :populate_json_attribute
    after_save :populate_json_attribute

    validates :building_name, presence: true, on: %i[building_name all]
    validates :gia, presence: true, on: %i[gia all]
    validates :security_type, presence: true, on: %i[security_type all]
    validates :building_type, presence: true, on: %i[building_type all]
    validates :building_ref, presence: true, on: %i[address all]
    validates :region, presence: true, on: %i[address all]
    validates :address_region_code, presence: true, on: %i[address all]
    validates :address_postcode, presence: true, on: %i[address all]

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

    def self.buildings_for_user(user_email)
      where("user_email = '" + Base64.encode64(user_email) + "'")
    end

    def self.building_by_reference(user_id, building_ref)
      find_by("user_email = '" + Base64.encode64(user_id) + "' and building_ref = '#{building_ref}'")
    end

    def populate_row
      populate_row_from_json(self[:building_json].deep_symbolize_keys)
    end

    STANDARD_BUILDING_TYPES = ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations',
                               'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary School', 'Special Schools',
                               'Universities and Colleges', 'Doctors, Dentists and Health Clinics', 'Nursery and Care Homes'].freeze

    def building_standard
      STANDARD_BUILDING_TYPES.include?(building_json['building_type'.to_sym] || building_type) ? 'STANDARD' : 'NON-STANDARD'
    end

    def building_type_list_titles
      { 'General office - Customer Facing' => 'General office areas and customer facing areas.',
        'General office - Non Customer Facing' => 'General office areas and non-customer facing areas.',
        'Call Centre Operations' => 'Call centre operations.',
        'Warehouses' => 'Large storage facility with limited office space and low density occupation by supplier personnel.',
        'Restaurant and Catering Facilities' => 'Areas including restaurants, deli-bars and coffee lounges areas used exclusively for consuming food and beverages.',
        'Pre-School' => 'Pre-school, including crèche, nursery and after-school facilities.',
        'Primary School' => 'Primary school facilities.',
        'Secondary School' => 'Secondary school facilities.',
        'Special Schools' => 'Special school facilities.',
        'Universities and Colleges' => '	University and college, including on and off site campus facilities but excluding student residential accommodation facilities.',
        'Doctors, Dentists and Health Clinics' => '	Community led facilities including doctors, dentists and health clinics.',
        'Nursery and Care Homes' => '	Nursery and care home facilities.',
        'Data Centre Operations' => 'Data centre operation.',
        'External parks, grounds and car parks' => '	External car parks and grounds including externally fixed assets - such as fences, gates, fountains etc.',
        'Laboratory' => 'Includes all Government facilities where the standard of cleanliness is high, access is restricted and is not public facing.',
        'Heritage Buildings' => 'Buildings of historical or cultural significance.',
        'Nuclear Facilities' => 'Areas associated with Nuclear activities.',
        'Animal Facilities' => 'Areas associated with the housing of animals such as dog kennels and stables.',
        'Custodial Facilities' => 'Facilities relating to the detention of personnel such as prisons and detention centres.',
        'Fire and Police Stations' => 'Areas associated with emergency services.',
        'Production Facilities' => 'An environment centred around a fabrication or production facility, typically with restricted access.',
        'Workshops' => 'Areas where works are undertaken such as joinery or metal working facilities',
        'Garages' => 'Areas where motor vehicles are cleaned, serviced, repaired and maintained.',
        'Shopping Centres' => 'Areas where retail services are delivered to the public.',
        'Museums or Galleries' => 'Areas are generally open to the public with some restrictions in place from time to time. Some facilities have no public access.',
        'Fitness or Training Establishments' => 'Areas associated with fitness and leisure such as swimming pools, gymnasia, fitness centres and internal / external sports facilities.',
        'Residential Buildings' => 'Residential accommodation / areas.',
        'Port and Airport buildings' => 'Areas associated with air and sea transportation and supporting facilities, such as airports, aerodromes and dock areas.',
        'List X Property' => 'A commercial site (i.e. non-Government) on UK soil that is approved to hold UK government protectively marked information marked as \'confidential\' and above. It is applied to a company\'s specific site and not a company as a whole.',
        'Hospitals' => 'Areas including mainstream medical, healthcare facilities such as hospitals and medical centres.',
        'Mothballed / Vacant / Disposal' => 'Areas which are vacant or awaiting disposal where no services are being undertaken.' }
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
        'building-ref': building_ref,
        address: {
          'fm-address-town': address_town,
          'fm-address-line-1': address_line_1,
          'fm-address-line-2': address_line_2,
          'fm-address-county': address_county,
          'fm-address-region': address_region,
          'fm-address-region-code': address_region_code,
          'fm-address-postcode': address_postcode
        }
      }.symbolize_keys
    end

    # rubocop:disable Metrics/AbcSize
    def populate_row_from_json(building_json)
      self.building_name = building_json[:building_name] || building_json[:name]
      self.description = building_json[:description]
      self.region = building_json[:region]
      self.building_ref = building_json['building-ref'.to_sym]
      self.building_type = building_json['building-type'.to_sym]
      self.security_type = building_json['security-type'.to_sym]
      self.gia = building_json[:gia]
      self.address_town = building_json[:address]['fm-address-town'.to_sym]
      self.address_line_1 = building_json[:address]['fm-address-line-1'.to_sym]
      self.address_line_2 = building_json[:address]['fm-address-line-2'.to_sym]
      self.address_county = building_json[:address]['fm-address-county'.to_sym]
      self.address_region = building_json[:address]['fm-address-region'.to_sym] || building_json[:address]['fm-nuts-region'.to_sym]
      self.address_postcode = building_json[:address]['fm-address-postcode'.to_sym]
      self.address_region_code = building_json[:address]['fm-address-region-code'.to_sym]
      determine_status
    end
    # rubocop:enable Metrics/AbcSize
  end
end
