module FacilitiesManagement
  class Building < ApplicationRecord
    belongs_to :user, foreign_key: :user_id, inverse_of: :buildings
    before_save :determine_status
    after_initialize :determine_status, :populate_building_json
    after_save :populate_building_json
    before_validation :determine_status

    attr_accessor :building_json

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

    def populate_building_json
      self.building_json = build_data_hash
    end

    def build_data_hash
      {
        'id':            id,
        'name':          building_name,
        'description':   description,
        'region':        region,
        'building-ref':  building_ref,
        'building-type': building_type,
        'security-type': security_type,
        'gia':           gia,
        'address':       {
          'fm-address-town':        address_town,
          'fm-address-line-1':      address_line_1,
          'fm-address-line-2':      address_line_2,
          'fm-address-county':      address_county,
          'fm-address-region':      address_region,
          'fm-address-region-code': address_region_code,
          'fm-address-postcode':    address_postcode
        }
      }.to_h
    end
  end
end
