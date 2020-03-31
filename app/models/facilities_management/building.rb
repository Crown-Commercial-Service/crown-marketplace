module FacilitiesManagement
  class Building < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :buildings
    attr_accessor :building_json

    before_save :populate_row, if: ->(building) { building.building_json.present? }
    before_save :determine_status
    after_initialize :populate_building_json, if: ->(building) { building[:building_json].blank? }
    after_save :populate_building_json, if: ->(building) { building[:building_json].blank? }
    before_validation :determine_status

    validates :building_name, presence: true, on: %i[building_name all]
    validates :gia, presence: true, on: %i[gia all]
    validates :security_type, presence: true, on: %i[security_type all]
    validates :building_type, presence: true, on: %i[building_type all]
    validates :building_ref, presence: true, on: %i[address all]
    validates :region, presence: true, on: %i[address all]
    validates :address_region_code, presence: true, on: %i[address all]
    validates :address_postcode, presence: true, on: %i[address all]

    private

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

    # rubocop:disable Metrics/AbcSize
    def populate_row
      self.building_name = building_json[:building_name]
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
      self.address_region = building_json[:address]['fm-address-region'.to_sym]
      self.address_postcode = building_json[:address]['fm-address-postcode'.to_sym]
      self.address_region_code = building_json[:address]['fm-address-region-code'.to_sym]
    end
    # rubocop:enable Metrics/AbcSize

    def populate_building_json
      self.building_json = {
        'id': id,
        'name': building_name,
        'description': description,
        'region': region,
        'building-ref': building_ref,
        'building-type': building_type,
        'security-type': security_type,
        'gia': gia,
        'address': {
          'fm-address-town': address_town,
          'fm-address-line-1': address_line_1,
          'fm-address-line-2': address_line_2,
          'fm-address-county': address_county,
          'fm-address-region': address_region,
          'fm-address-region-code': address_region_code,
          'fm-address-postcode': address_postcode
        }
      }.to_h
    end
  end
end
