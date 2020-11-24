module FacilitiesManagement
  class FindAddressHelper
    include FacilitiesManagement::FindAddressConcern

    attr_accessor :object, :address_postcode, :address_postcode_symbol, :address_line1, :address_line2, :address_town, :address_county

    def initialize(object, organisaiton_prefix)
      @object = object
      if organisaiton_prefix
        @address_postcode = object.organisation_address_postcode
        @address_postcode_symbol = :organisation_address_postcode
        @address_line1 = object.organisation_address_line_1
        @address_line2 = object.organisation_address_line_2
        @address_town = object.organisation_address_town
        @address_county = object.organisation_address_county
      else
        @address_postcode = object.address_postcode
        @address_postcode_symbol = :address_postcode
        @address_line1 = object.address_line_1
        @address_line2 = @object.address_line_2
        @address_town = object.address_town
      end
    end

    def postcode_search_visible?
      @postcode_search_visible ||= address_postcode.blank? || object.errors[address_postcode_symbol].any?
    end

    def postcode_change_visible?
      @postcode_change_visible ||= address_postcode.present? && object.errors[address_postcode_symbol].none? && address_line1.blank?
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
      [address_line1, address_line2, address_town, address_county].reject(&:blank?).join(', ') + " #{address_postcode}"
    end
  end
end
