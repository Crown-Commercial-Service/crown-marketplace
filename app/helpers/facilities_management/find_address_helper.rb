module FacilitiesManagement
  class FindAddressHelper
    include FacilitiesManagement::FindAddressConcern

    attr_accessor :object, :address_keys, :address_postcode, :address_line1, :address_line2, :address_town, :address_county

    def initialize(object, organisaiton_prefix)
      @object = object
      @address_keys = if organisaiton_prefix
                        @county_field = true
                        ATTRIBUTES_TO_KEY[:organisaiton_prefix_true]
                      else
                        @county_field = false
                        ATTRIBUTES_TO_KEY[:organisaiton_prefix_false]
                      end

      @address_postcode = object[@address_keys[:address_postcode]]
      @address_line1 = object[@address_keys[:address_line1]]
      @address_line2 = object[@address_keys[:address_line2]]
      @address_town = object[@address_keys[:address_town]]
      @address_county = object[@address_keys[:address_county]]
    end

    def postcode_search_visible?
      @postcode_search_visible ||= address_postcode.blank? || object.errors[@address_keys[:address_postcode]].any?
    end

    def postcode_change_visible?
      @postcode_change_visible ||= address_postcode.present? && object.errors[@address_keys[:address_postcode]].none? && address_line1.blank?
    end

    def select_an_address_visible?
      @select_an_address_visible ||= postcode_change_visible?
    end

    def full_address_visible?
      @full_address_visible ||= address_line1.present?
    end

    def valid_addresses
      @valid_addresses ||= find_addresses_by_postcode(address_postcode.to_s)
    end

    def address_count
      @address_count ||= valid_addresses.length
    end

    def address_in_a_line
      [address_line1, address_line2, address_town, address_county].compact_blank.join(', ') + " #{address_postcode}"
    end

    ATTRIBUTES_TO_KEY = {
      organisaiton_prefix_true: {
        address_postcode: :organisation_address_postcode,
        address_line1: :organisation_address_line_1,
        address_line2: :organisation_address_line_2,
        address_town: :organisation_address_town,
        address_county: :organisation_address_county
      },
      organisaiton_prefix_false: {
        address_postcode: :address_postcode,
        address_line1: :address_line_1,
        address_line2: :address_line_2,
        address_town: :address_town
      }
    }.freeze
  end
end
