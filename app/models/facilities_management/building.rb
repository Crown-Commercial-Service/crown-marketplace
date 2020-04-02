module FacilitiesManagement
  class Building < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :buildings

    before_save :populate_other_data, :determine_status
    before_validation :determine_status
    after_find :populate_json_attribute

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
    end

    def building_json
      if building_name.present?
        json
      else
        attributes['building_json']
      end
    end

    def populate_json_attribute
      self[:building_json] = json.deep_symbolize_keys if building_name.present?
      populate_row_from_json(self[:building_json].deep_symbolize_keys) if building_name.blank? && self[:building_json]['name'].present?
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

    def json
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
